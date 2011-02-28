require 'rubygems'
require 'json'

require 'kindle_fs/collection'

module KindleFS
  class Collections
    # simple getter for the collections hash
    def self.data
      @@collections
    end

    # proxy all other method calls to the collections hash
    def method_missing(name, *args, &block)
      @@collections.send(name, *args, &block)
    end

    # writes the collection back to the kindle
    def self.save
      file = File.new(File.join(@@kindle_root, 'system', 'collections.json'), 'w+')
      JSON.dump(@@collections, file)
      file.close
    end

    # loads the collections file from the kindles system directory
    def self.load(kindle_root)
      @@kindle_root = kindle_root
      file = File.new(File.join(@@kindle_root, 'system', 'collections.json'), 'r')
      @@collections = JSON.load(file)
      file.close
      # converts the collections subhashes into collection instances
      # this results in an easier access
      @@collections.merge!(@@collections) do |name, collection|
        Collection.new.merge(collection)
      end
    end
  end
end
