require 'fileutils'

class S3Uploader
  include Sidekiq::Worker
  sidekiq_options queue: :high, :retry => 5

  sidekiq_retry_in do |count|
    10 * (count + 1) # (i.e. 10, 20, 30, 40, 50 ...give up)
  end

  sidekiq_retries_exhausted do |msg|
    Rails.logger.warn "Failed #{msg['class']} with #{msg['args']}: #{msg['error_message']}"
  end

  def perform (file_id)
    Rails.logger.info "Processing new file: #{file_id}"
    file = LegacyFile.find(file_id)

    dirname = File.dirname file.full_filename
    FileUtils.mkdir_p(dirname) unless Dir.exists? dirname

    # Load meta_data from previous file processing
    begin 
      meta_data = JSON.parse( File.read file.metadata_full_filename ) if File.exists? file.metadata_full_filename
    rescue => e
      puts "Error reading JSON file: #{file.metadata_full_filename}"
      puts "ERROR: #{e.message}"
    end
    
    if meta_data.nil? || meta_data['url'].blank?
      connection = Fog::Storage.new(
         :provider => 'AWS',
         :aws_access_key_id => Rails.configuration.aws.access_key_id,
         :aws_secret_access_key => Rails.configuration.aws.access_key_secret
      )

      # using :new because we know bucket already exists
      files_bucket = connection.directories.new(key: Rails.configuration.files.s3_bucket)
      # dir = connection.directories.create(:key => 'foo', :public => true)# no request made

      # Create file exists, create it
      unless uploaded_file = files_bucket.files.head( file.chrFileName )
        uploaded_file = files_bucket.files.create(
          key: "#{file.idFile}-#{file.chrFileName}",
          body: Base64.decode64(file.blobFileDataBase64),
          public: true
        )
        Rails.logger.info "Created new file: #{uploaded_file.key}"
      end
      # update the contents of the resume file
      # file = directory.files.get('resume.ht1l')
      # file.body = File.open("/path/to/my/resume.html")
      # file.save

      # also, create(attributes) is just new(attributes).save, so you can also do:
      # file = directory.files.new({
      #   :key    => 'resume.html',
      #   :body   => '<replacement data>',
      #   :public => true
      # })
      # file.save

      file.url = Addressable::URI.join("https://s3.amazonaws.com/", ['/',Rails.configuration.files.s3_bucket,'/'].join, "#{file.idFile}-#{file.chrFileName}")

      # Write JSON meta data
      File.open( file.metadata_full_filename,"w") do |f|
        f.write(file.to_json)
      end
      Rails.logger.info "Saved JSON file: #{file.metadata_full_filename}"
    end
  end

end
