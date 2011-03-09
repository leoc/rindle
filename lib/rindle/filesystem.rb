module Rindle
  class Filesystem
    def initialize kindle_root
      @kindle_root = kindle_root
    end
    
    def contents path
      case path
      when '/'
        [ 'collections', 'books', 'pictures' ]
      when /^\/collections/
        Collection.all.map(&:name)
      when /^\/collections\/([A-Za-z0-9_\-\s'"]+)/
        collection = Collection.find($1)
        collection.files.map(&:name)
      else
        []
      end
    rescue Exception => e
      puts e.inspect
      puts e.backtrace
    end
    
    def file?(path)
      if path =~ /\/(collections|books|pictures)/
        false
      elsif path =~ /^\/collections\/([A-Za-z0-9_\-\s'"]+)$/
        false
      else
        true
      end
    end
    
    def directory?(path)
#      puts "----- #{path} file/dir?"
      !file?(path)
    end
    
    def executable?(path)
#      puts "----- executable? #{path}"
      false
    end

    def size(path)
#      puts "----- size #{path}"
      500
    end
    
    def can_delete?(path)
#      puts "----- can_delete? #{path}"
      true
    end
    
    def can_write?(path)
#      puts "----- can_write? #{path}"
      true
    end

    def can_mkdir?(path)
#      puts "----- can_mkdir? #{path}"
      true
    end
    
    def can_rmdir?(path)
#      puts "----- can_rmdir? #{path}"
      true
    end

    def touch(path)
#      puts "----- touch #{path}"
    end
    
    def mkdir(path)
#      puts "----- mkdir #{path}"
    end

    def rmdir(path)
#      puts "----- rmdir #{path}"
    end
    
    def write_to path, body
#      puts "write to #{path} - #{body.length}"
    end
    
    def read_file path
#      puts "read file #{path}"
      "dummy"
    end
  end
end
