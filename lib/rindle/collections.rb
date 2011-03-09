require 'rubygems'
require 'json'

require 'rindle/collection'

module Rindle
  class Collections < Hash
    
    class NoSuchFile < Exception; end
    
    def initialize(kindle_root)
      @collections_file = File.join(kindle_root, 'system', 'collections.json')
    end

    def self.load(kindle_root)
      Collections.new(kindle_root).load
    end
    
    def save
      File.open(@collections_file, 'w+') do |file|
        JSON.dump(@collections, file)
      end
    end

    def load
      raise NoSuchFile, "Not found: #{@collections_file}" unless File.exists?(@collections_file)
      File.open(@collections_file, 'r') do |file|
        merge!(JSON.load(file))
      end
      self
    end
  end
end
