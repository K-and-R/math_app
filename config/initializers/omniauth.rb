Rails.application.config.middleware.use OmniAuth::Builder do
  
  %w(Facebook LinkedIn Github Yahoo).each do |service_name|
    service = service_name.downcase.to_sym
    if Rails.configuration.oauth[service] && Rails.configuration.oauth[service].app_id && Rails.configuration.oauth[service].secret
      # Enabled unless explictly disabled
      Rails.configuration.oauth[service].enabled = true if Rails.configuration.oauth[service].enabled.nil?
      provider service.downcase.to_sym, 
        Rails.configuration.oauth[service].app_id,
        Rails.configuration.oauth[service].secret, 
        :scope => Rails.configuration.oauth[service].permissions
    else
      # if Rails.env.production?
      #   raise "#{service} OAuth config missing in production!"
      # else
        Rails.logger.warn "#{service_name} OAuth config missing."
      # end
    end
  end

  if Rails.configuration.oauth.twitter && Rails.configuration.oauth.twitter.app_id && Rails.configuration.oauth.twitter.secret
    # Enabled unless explictly disabled
    Rails.configuration.oauth.twitter.enabled = true if Rails.configuration.oauth.twitter.enabled.nil?
    provider :twitter, 
      Rails.configuration.oauth.twitter.app_id,
      Rails.configuration.oauth.twitter.secret
  else
    # if Rails.env.production?
    #   raise "#{service} OAuth config missing in production!"
    # else
      Rails.logger.warn "Twitter OAuth config missing."
    # end
  end

  if Rails.configuration.oauth.google && Rails.configuration.oauth.google.app_id && Rails.configuration.oauth.google.secret
    # Enabled unless explictly disabled
    Rails.configuration.oauth.google.enabled = true if Rails.configuration.oauth.google.enabled.nil?
    provider :google_oauth2, 
      Rails.configuration.oauth.google.app_id,
      Rails.configuration.oauth.google.secret, 
      :scope => Rails.configuration.oauth.google.permissions
  else
    # if Rails.env.production?
    #   raise "#{service} OAuth config missing in production!"
    # else
      Rails.logger.warn "Google OAuth config missing."
    # end
  end

  if Rails.configuration.oauth.openid && Rails.configuration.oauth.openid.app_id && Rails.configuration.oauth.openid.secret
    # Enabled unless explictly disabled
    Rails.configuration.oauth.openid.enabled = true if Rails.configuration.oauth.openid.enabled.nil?
    provider :open_id, 
      Rails.configuration.oauth.openid.app_id,
      Rails.configuration.oauth.openid.secret, 
      :scope => Rails.configuration.oauth.openid.permissions
  else
    # if Rails.env.production?
    #   raise "#{service} OAuth config missing in production!"
    # else
      Rails.logger.warn "OpenID OAuth config missing."
    # end
  end

end
