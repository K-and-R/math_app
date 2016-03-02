class Authentication < ActiveRecord::Base
  has_paper_trail
  
  belongs_to :user
  # attr_accessible :user, :provider, :uid, :info
  
  serialize :info
  serialize :auth
  validates_uniqueness_of :uid, :scope => :provider
  
  ##
  # Returns the titleized name of the Provider, with some special cases where simple titleize isn't sufficient.
  def provider_display_name
    SocialNetwork.find_by_provider(provider).display_name
  end
  
  ##
  # Store data provided by omniauth
  def apply_omniauth(omniauth)
    self.provider = omniauth['provider']
    self.uid = omniauth['uid']
    self.info = omniauth.info
    self.auth = omniauth.except('info')
    save
  end
  
  def has_avatar?
    false
  end
  
  def avatar
  end
  
  ##
  # When an OAuth authentication occurs, finds an existing authentication record to match the
  # authentication, or creates a new one containing the information.
  # Then also updates the information with the latest information provided in the omniauth data.
  def self.find_or_create_by_omniauth(omniauth)
    authentication = find_by_provider_and_uid(omniauth['provider'], omniauth['uid'])
    
    if !authentication
      authentication = create
    end
    
    authentication.apply_omniauth(omniauth)
    
    authentication
  end
end
