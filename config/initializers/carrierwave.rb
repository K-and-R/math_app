CarrierWave.configure do |config|
  if Rails.env.development?
    config.storage = :file
  elsif Rails.env.test?
    config.storage = :file
    config.enable_processing = false
  else
    config.storage = :aws
    config.aws_bucket = Rails.configuration.files.aws_bucket
    config.aws_acl = 'public-read'
    config.aws_credentials = {
      access_key_id: Rails.configuration.aws.access_key_id,
      secret_access_key: Rails.configuration.aws.secret_access_key,
      region: Rails.configuration.aws.region,
    }
  end
end
