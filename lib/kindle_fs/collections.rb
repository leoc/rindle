require 'rubygems'
require 'json'

module KindleFS
  class Collections < Hash
    def initialize kindle_root
      @collections_file = File.join(kindle_root, 'system', 'collections.json')
    end

    def load
      yield 0.0 if block_given?
      self.merge(JSON.load(@collections_file))
      yield 1.0 if block_given?
    end
  end
end
