ActiveRecord::Base.raise_in_transactional_callbacks = true
ActiveRecord::Base.dump_schema_after_migration = Rails.env.development?
# These don't seem to be getting set from the database.yml file.
ActiveRecord::Base.connection.pool.instance_variable_set('@size', Rails.configuration.db.pool_size)
ActiveRecord::Base.connection.pool.instance_variable_get('@reaper').instance_variable_set('@frequency', Rails.configuration.db.reaping_frequency)

class ActiveRecord::Base
  # Following method – To skip the ActiveRecord callback
  def self.skip_callback(callback, &block)
    if respond_to?(callback)
      method = instance_method(callback)
      remove_method(callback)
      define_method(callback){ true }
      yield
      remove_method(callback)
      define_method(callback, method)
    else 
      yield
    end
  end
end
