module ApplicationHelper
  SidebarPanel = Struct.new(:type, :heading, :messages, :name) do
    # self.name = heading.underscore if heading.present? && name.blank?
    def add_message(message)
      self.messages ||= []
      self.messages << message
    end
  end

  def create_sidebar_panel(hash)
    sidebar_panels << SidebarPanel.new(hash[:type], hash[:heading], hash[:messages], hash[:name])
    sidebar_panels.last
  end

  def sidebar_panels
    @sidebar_panels ||= []
  end

  def display_base_errors(resource)
    return '' if (resource.errors.empty?) || (resource.errors[:base].empty?)
    messages = resource.errors[:base].map { |msg| content_tag(:p, msg) }.join
    html = <<-HTML
    <div class="alert alert-error alert-block">
      <button type="button" class="close" data-dismiss="alert">&#215;</button>
      #{messages}
    </div>
    HTML
    html.html_safe
  end

  ##
  # Extend Flash to allow for additional message types
  def bootstrap_class_for_flash(flash_type)
    case flash_type.to_sym
      when :error, :alert
        'alert-danger'
      when :notice
        'alert-info'
      when :warn
        'alert-warning'
      else
        "alert-#{flash_type.to_s}"
    end
  end

  # FIXME: this preferred_time_zone should be a class method that uses a config default
  def current_timezone
    if current_user.present?
      tz = current_user.preferred_time_zone
    else
      tz = User.new.preferred_time_zone
    end
    ActiveSupport::TimeZone.new tz.gsub(' ', '_')
  end

  def devise_resource_name
    :user
  end

  def devise_resource
    @devise_resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def social_networks
    SocialNetwork.enabled.sort { |a, b| a.short_name <=> b.short_name }
  end

  def current_or_guest_user
    if user_signed_in?
      if session[:guest_user_id]

        # Hand over data if guest logs in
        #
        # data goes here
        #
        current_user.save!

        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  private

  def guest_user
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)
  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
    session[:guest_user_id] = nil
    guest_user
  end

  def create_guest_user
    # http://stackoverflow.com/questions/7465467/devise-create-user-account-with-confirmed-without-sending-out-an-email
    u = User.new name: 'guest', email: "guest_user_#{Time.zone.now.to_i}#{rand(99)}"
    u.skip_confirmation!
    u.save! validate: false
    session[:guest_user_id] = u.id
    u
  end
end
