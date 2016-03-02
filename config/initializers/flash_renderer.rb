module ActionController
  module Flash
    def render(*args)
      options = args.last.is_a?(Hash) ? args.last : {}

      if alert = options.delete(:alert)
        flash[:alert] = alert
      end

      if notice = options.delete(:notice)
        flash[:notice] = notice
      end

      if alert = options.delete(:success)
        flash[:success] = alert
      end

      if notice = options.delete(:error)
        flash[:error] = notice
      end

      if other = options.delete(:flash)
        flash.update(other)
      end

      super(*args)
    end
  end
end

# module ActionController
#   class Base

#     alias_method :old_render, :render
#     def render(*args)
#       options = args.last.is_a?(Hash) ? args.last : {}

#       if alert = options.delete(:alert)
#         flash[:alert] = alert
#       end

#       if notice = options.delete(:notice)
#         flash[:notice] = notice
#       end

#       if alert = options.delete(:success)
#         flash[:success] = alert
#       end

#       if notice = options.delete(:error)
#         flash[:error] = notice
#       end

#       if other = options.delete(:flash)
#         flash.update(other)
#       end

#       old_render(*args)
#     end

#   end
# end
