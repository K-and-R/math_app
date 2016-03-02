# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

puts 'Creating Roles.'
%w(admin user guest).each do |role|
  Role.find_or_create_by(name: role)
end

puts 'Creating Phone Types.'
%w(mobile home work main home-fax work-fax google-voice custom).each do |phone_type|
  PhoneType.find_or_create_by(name: phone_type)
end

puts 'Creating SocialNetworks.'
SocialNetwork.find_or_create_by({ short_name: 'facebook', name: 'Facebook' })
SocialNetwork.find_or_create_by({ short_name: 'twitter', name: 'Twitter' })
SocialNetwork.find_or_create_by({ short_name: 'google', name: 'Google' })
SocialNetwork.find_or_create_by({ short_name: 'linkedin', name: 'LinkedIn' })
SocialNetwork.find_or_create_by({ short_name: 'github', name: 'Github' })
SocialNetwork.find_or_create_by({ short_name: 'yahoo', name: 'Yahoo!' })
SocialNetwork.find_or_create_by({ short_name: 'openid', name: 'OpenID' })

# Build some Users
File.open(File.expand_path('../default_users.yml', __FILE__), 'r') do |file|
  YAML::load(file).each do |user_attrs|
    # Clean up user_attrs
    user_attrs.symbolize_keys!
    user_attrs[:confirmed_at] = Time.zone.now.utc
    user_attrs[:admin] = !(
      user_attrs[:admin].nil? ||
      user_attrs[:admin] == '' ||
      user_attrs[:admin] == 'no' ||
      user_attrs[:admin] == 'false' ||
      user_attrs[:admin] == 0
    )
    is_admin = user_attrs.delete(:admin)
    # Create user
    User.find_or_initialize_by(email: user_attrs[:email]) do |u|
      puts "== Creating new user account for #{user_attrs[:name]} <#{user_attrs[:email]}>" << ( is_admin ? ' as admin' : '' )
      # We need to set each attribute individually because encrypted_password cannot be set by mass assignment ...and should remain that way.
      user_attrs.each {|k,v| u[k]=v}
      # We aren't validating these passwords
      u.skip_validation_for :password
      u.save!
      u.roles = [Role.find_by(name: 'admin')] if is_admin
    end
  end
end

# # Build some Clients
# require 'factory_girl_rails'
# puts "Creating some sample Client records."
# (1..4).each do
#   client = FactoryGirl.create :client
# end
