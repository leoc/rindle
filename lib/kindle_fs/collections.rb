require 'rubygems'
require 'json'

require 'kindle_fs/collection'

# Kindle::Collections derives from Array and stores all the Collection objects
# additionally it handles save/load procedures
module Kindle
  class Collections < Hash
    
    class NoSuchFile < Exception; end
    
    def initialize(kindle_root)
      @collections_file = File.join(kindle_root, 'system', 'collections.json')
      load
    end
    
    # writes the collection back to the kindle
    def save
      File.open(@collections_file, 'w+') do |file|
        JSON.dump(@collections, file)
      end
    end

    # loads the collections file from the kindles system directory
    def load
      raise NoSuchFile, "Not found: #{@collections_file}" unless File.exists?(@collections_file)
      
      File.open(@collections_file, 'r') do |file|
        merge!(JSON.load(file))  
      end
    end
  end
end
