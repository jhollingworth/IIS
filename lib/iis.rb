class IIS 

    def initialize(*args)
      case args.size
        when 0 then
          require File.dirname(__FILE__) + '/Microsoft.Web.Administration.dll'
          @manager = Microsoft::Web::Administration::ServerManager.new
        when 1
          @manager = args[0]
        else raise "Cannot have more than one argument"
      end
    end

	def has?(type, name)
		!get_type_collection(type)[name].nil?
	end

    def get(type, name)
      get_type_collection(type)[name]
    end

	def create(type, name, options = nil) 
		raise "#{type} #{name} already exists" if has?(type, name)
        obj = type == :site ? add_site(name, options) : get_type_collection(type).add(name)
		yield(obj)
		@manager.commit_changes
	end

    def delete(type, name)
      obj = get(type,name)

      if(obj != nil)
        obj.delete
        @manager.commit_changes
      end
    end

	private

    def add_site(name, options)
      raise "Must specify path to site" if !options.has_key?(:path)
      raise "Must spcify port to site" if !options.has_key?(:port)

      @manager.sites.add(name, options[:path].to_s, options[:port].to_i)
    end
	
	def get_type_collection(type)
		case type
			when :app_pool then @manager.application_pools
			when :site then @manager.sites
			else raise "Unknown type #{type}"
		end
	end
end
