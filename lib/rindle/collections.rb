require 'rubygems'
require 'json'

require 'rindle/collection'

class Rindle
  class Collections < Hash

    class NoSuchFile < Exception; end

    def initialize(kindle_root)
      @collections_file = File.join(kindle_root, 'system', 'collections.json')
    end

    def self.load(kindle_root)
      Collections.new(kindle_root).load
    end

    def save
      hash = {}
      values.each do |col|
        hash.merge! col.to_hash
      end
      File.open(@collections_file, 'w+') do |f|
        JSON.dump(hash, f)
      end
    end

    def load
      unless File.exists?(@collections_file)
        raise NoSuchFile, "Not found: #{@collections_file}"
      end

      hash = File.open(@collections_file, 'r') do |file|
        begin
          JSON.load(file)
        rescue Exception => e
          {}
        end
      end
      hash.each_pair do |name, data|
        col = Collection.new name, :indices => data['items'],
                                   :last_access => data['lastAccess']
        self[col.name] = col
      end
      self
    end
  end
end
