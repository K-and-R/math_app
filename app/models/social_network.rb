class SocialNetwork < ActiveRecord::Base
  
  ##
  # Returns the titleized name of the Provider, with some special cases where simple titleize isn't sufficient.
  def display_name
    if short_name == 'openid'
      "OpenID"
    elsif short_name == 'google'
      "Google"
    elsif short_name == 'linkedin'
      "LinkedIn"
    else
      short_name.titleize
    end
  end
  
  def provider
    if short_name == 'openid'
      :open_id
    elsif short_name == 'google'
      :google_oauth2
    else
      short_name
    end
  end

  def enabled?
    !!(Rails.configuration.oauth[short_name] && Rails.configuration.oauth[short_name].enabled)
  end

  def self.find_by_provider provider
    case provider 
    when :open_id
      short_name = 'open_id'
    when :google
      short_name = 'google_oauth2'
    else
      short_name = provider.to_s
    end
    self.find_by_short_name short_name
  end

  def self.enabled
    self.all.each.map {|s| s if s.enabled? } .compact
  end
end
