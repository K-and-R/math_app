# lib/tasks/db.rake
namespace :db do
  namespace :adapter do
    desc 'Dumps the database to db/[DB_NAME].[ADAPTER]dump.bz2'
    task dump: :environment do
      cmd = nil
      with_config do |config|
        cmd = dump_cmd config
      end
      puts cmd
      exec cmd
    end

    desc 'Restores the database dump at db/[DB_NAME].[ADAPTER]dump.bz2'
    task load: :environment do
      cmd = nil
      with_config do |config|
        cmd = load_cmd config
      end
      Rake::Task['db:drop'].invoke
      Rake::Task['db:create'].invoke
      puts cmd
      exec cmd
    end

    def dump_cmd(params)
      @params = params
      case @params[:adapter]
        when 'mysql', 'mysql2'
          @params[:dump_exec] = 'mysqldump'
          cmd = mysql_dump_command
        when 'postgresql', 'postgres'
          @params[:dump_exec] = 'pg_dump'
          cmd = pg_dump_command
      end
      cmd << " | bzip2 -z9c > #{dump_dir}/#{dump_filename}.bz2"
    end

    def load_cmd(params)
      @params = params
      case @params[:adapter]
        when 'mysql', 'mysql2'
          @params[:dump_exec] = 'mysqldump'
          cmd = "bzcat -dc #{dump_dir}/#{dump_file(params)}.bz2 |"\
                 " #{mysql_restore_command}"
        when 'postgresql', 'postgres'
          @params[:dump_exec] = 'pg_dump'
          cmd = "bzcat -dc #{dump_dir}/#{dump_filename}.bz2 |"\
                 " #{pg_restore_command}"
      end
      cmd
    end

    def mysql_dump_command
      retval = ''
      retval << "#{@params[:dump_exec]} --databases --opt "
      retval << mysql_host
      retval << mysql_port
      retval << mysql_user
      retval << mysql_password
      retval << " #{@params[:database]}"
      retval
    end

    def mysql_restore_command
      fail "Data file not found: #{dump_dir}/#{dump_filename}.bz2" unless File.exist?("#{dump_dir}/#{dump_filename}.bz2")
      retval = ''
      retval << 'mysql '
      retval << mysql_host
      retval << mysql_port
      retval << mysql_user
      retval << mysql_password
      retval << " #{@params[:database]}"
      retval
    end

    def mysql_user
      " --user=#{@params[:username]}" if @params[:username]
    end

    def mysql_password
      " --password=#{@params[:password]}" if @params[:password]
    end

    def mysql_host
      " --host=#{@params[:host]}" if @params[:host]
    end

    def mysql_port
      " --port=#{@params[:port]}" if @params[:port]
    end

    def pg_dump_command
      retval = ''
      retval << pg_password
      retval << "#{@params[:dump_exec]} "
      retval << ' --verbose --clean --no-owner --no-acl --format=c'
      retval << pg_host.to_s
      retval << pg_port.to_s
      retval << pg_user.to_s
      retval << " #{@params[:database]}"
      retval
    end

    def pg_restore_command
      fail "Data file not found: #{dump_dir}/#{dump_filename}.bz2" unless File.exist?("#{dump_dir}/#{dump_filename}.bz2")
      retval = ''
      retval << pg_password
      retval << 'pg_restore '
      retval << ' --verbose --clean --no-owner --no-acl'
      retval << pg_host.to_s
      retval << pg_port.to_s
      retval << pg_user.to_s
      retval << "  --dbname=#{@params[:database]}"
      retval
    end

    def pg_user
      " --username=#{@params[:username]}" if @params[:username]
    end

    def pg_password
      "PGPASSWORD=\"#{@params[:password]}\" " if @params[:password]
    end

    def pg_host
      " --host=#{@params[:host]}" if @params[:host]
    end

    def pg_port
      " --port=#{@params[:port]}" if @params[:port]
    end

    def dump_dir(dir = '')
      "#{Rails.root}/db#{dir}"
    end

    def dump_filename
      "#{@params[:database]}.#{@params[:dump_exec]}"
    end
  end

private

  def with_config
    yield ActiveRecord::Base.connection_config
  end
end
