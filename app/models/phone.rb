class Phone < ActiveRecord::Base
  belongs_to :user
  belongs_to :phone_type

  validates :user_id, presence: true
  validates :number, uniqueness: {scope: :user_id}

  def type
    phone_type.name
  end
  def type= name
    phone_type PhoneType.find_by(name: name)
  end
end
