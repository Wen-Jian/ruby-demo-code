module ApplicationHelper
    class MemCache
        options = { :username => 'username', :password => 'password' }
        Cache = Dalli::Client.new('cache:11211', options)
        def self.set(key, val, expir_in=DateTime.now.utc.beginning_of_day + 1.day - DateTime.now.utc)
            MemCache::Cache.set(key, val, expir_in)
        end

        def self.get(key)
            return MemCache::Cache.get(key)
        end
    end
end
