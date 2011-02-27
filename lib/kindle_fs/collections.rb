require 'rubygems'
require 'json'

require 'kindle_fs/collection'

module KindleFS
  class Collections
    def initialize kindle_root
      @collections_file = File.new(File.join(kindle_root, 'system', 'collections.json'))
      @collections = []
    end
    
    def all
      @collections.keys.map do |name|
        name.gsub('@en-US', '')
      end
    end
    
    def exists?(name)
      !@collections["#{name}@en-US"].nil?
    end
    
    # creates a new 
    def create(name)
      unless exists?(name)
        @collections["#{name}@en-US"] = {
          'items' => [],
          'lastAccess' => Time.now.to_i
        }
      end
      save
    end

    def add_item collection_name, item
      collection = get(collection_name)
      collection.add_item(item)
      save
    end

    def delete(name)
      if exists?(name)
        @collections.remove
      end
      save
    end

    def rename(old, new)
      if exists?(old)
        @collections["#{new}@en-US"] = @collections.delete("#{old}@en-US")
      end
      save
    end
    
    def get(name)
      @collections["#{name}@en-US"]
    end
    
    def save
      JSON.dump(@collections, @collections_file)
    end
    
    def load
      @collections = JSON.load(@collections_file)
      @collections.merge!(@collections) do |name, collection|
        Collection.new.merge(collection)
      end
    end
  end
end
