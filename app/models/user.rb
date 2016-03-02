class User < ActiveRecord::Base
  include Rails.application.routes.url_helpers # needed for _path helpers to work in models

  has_paper_trail
  rolify

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable,  :confirmable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :lockable

  has_many :authentications, dependent: :destroy, after_add: :new_authentication_added
  has_many :phones, dependent: :destroy

  accepts_nested_attributes_for :phones, allow_destroy: true

  can_skip_validation_for :password
  validates :email, presence: true, uniqueness: { case_sensitive: false }, email: true
  validates :password, presence: true, on: [:create, :update], unless: proc { |u| u.skip_password_validation? }
  validate :passwords_match?, on: [:create, :update], unless: proc { |u| u.skip_password_validation? }

  scope :accepted, -> { where('accepted_invite_at IS NOT NULL') }
  scope :not_accepted, -> { where('accepted_invite_at IS NULL') }

  def self.valid_attribute?(attr, value)
    mock = self.new(attr => value)
    mock.valid? || !mock.errors.has_key?(attr)
  end

  def self.find_by_token(url_token)
    self.find_by(invitation_token: url_token) || self.find_by(invitation_token: Digest::SHA256.hexdigest(url_token))
  end

  ##
  # When a new authentication is added to this user, take any information from it that we want
  # to place in the user, if it's need of anything.
  def new_authentication_added(authentication)
    # Take the email of the new OAuth if we don't already have an email address for this user
    self.email = authentication.info.email if email.blank? && authentication.info.email.present?

    # Take the email of the new OAuth if we don't already have an email address for this user
    self.name = authentication.info.name if name.blank? && authentication.info.name.present?
  end

  def has_password?
    !!encrypted_password.present?
  end

  # ##
  # # Don't require a password if it's currently blank and they authenticate using a social network.
  # # Or if we are skipping password validation
  # def password_required?
  #   !skip_password_validation? && authentications.empty? && !password.blank? && super
  # end

  def password_required?
    if skip_password_validation?
      return false
    else
      # Required if
      authentications.empty? && super
    end
  end

  def passwords_match?
    errors.add(:password, 'Passwords must match') unless password == password_confirmation
  end

  ##
  # Used by the ActionAdmin view to display an admin link to a record of this class.
  #
  def admin_path
    admin_user_path(self)
  end

  def first_name
    name.split(' ').first
  end

  def display_name
    name || email
  end

  def avatar_url
    self[:avatar_url] || begin
      if authentications.empty? || authentications.first.user_info.image.empty?
        gravatar_id = Digest::MD5.hexdigest(email.downcase)
        "//gravatar.com/avatar/#{gravatar_id}.png?s=48&d=mm&r=pg"
      else
        authentications.first.user_info.image
      end
    end
  end

  def admin?
    has_role?(:admin)
  end

  def send_invitation_email
    if new_record? || user_id_changed?
      url_token, self.invitation_token = generate_invitation_token
      UserMailer.invitation(self, url_token).deliver
      User.skip_callback(:send_invitation_email) do
        self.invited_at = Time.now.utc
        self.save
      end
    end
  end

  protected

  def generate_invitation_token
    limit = 10
    counter = 0
    loop do
      counter += 1
      url_token = Devise.friendly_token
      db_token = Digest::SHA256.hexdigest(url_token)
      break [url_token,db_token] unless User.find_first({ invitation_token: db_token })
      raise "Too many attempts to generate_invitation_token" if counter > limit
    end
  end
end
