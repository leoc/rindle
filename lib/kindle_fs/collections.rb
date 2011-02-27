require 'rubygems'
require 'json'

require 'kindle_fs/collection'

module KindleFS
  class Collections
    def self.data
      @@collections
    end
    
    def method_missing(name, *args, &block)
      @collections.send(name, *args, &block)
    end
    
    def self.save
      JSON.dump(@@collections, @@collections_file)
    end
    
    def self.load(kindle_root)
      @@collections_file = File.new(File.join(kindle_root, 'system', 'collections.json'))
      @@collections = JSON.load(@collections_file)
      @@collections.merge!(@collections) do |name, collection|
        Collection.new.merge(collection)
      end
    end
  end
end
