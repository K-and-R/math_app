namespace :files do

  desc "Queue files for upload"
  task :queue_legacy_files_for_upload, [] => :environment do 
    puts "Fetching files list from DB:"

    total = LegacyFile.count
    counter = success = skipped =0
    LegacyFile.select([:idFile,:chrFileName,:chrMD5]).each do |file| 
      counter += 1
      
      dirname = File.dirname file.full_filename
      FileUtils.mkdir_p(dirname) unless Dir.exists? dirname

      # Load meta_data from previous file processing
      begin 
        meta_data = JSON.parse( File.read file.metadata_full_filename ) if File.exists? file.metadata_full_filename
      rescue => e
        puts "Error reading JSON file: #{file.metadata_full_filename}"
        puts "ERROR: #{e.message}"
      end
      
      puts "Processing #{counter} of #{total} (#{(counter/total).round} %): #{file.chrFileName}"
      if meta_data.nil? || meta_data['url'].blank?
        file.upload_to_s3 1.second.from_now
        success += 1
      else 
        puts "Skipping : #{file.chrFileName}"       
        skipped += 1
      end
    end 
    puts "Done. Processed #{counter} files of #{total}; #{success} successful / #{skipped} skipped"
  end
  
end
