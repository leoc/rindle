module KindleFS
  class Filesystem
    def initialize kindle_root, collections, index
      @kindle_root = kindle_root
      @collections = collections
      @index = index
    end
    
    def contents path
      puts "contents #{path}"
      if path == '/collections'
        [ '/collections', '/books', 'pictures' ]
      else
        [ 'test' ]
      end
    end
    
    def file?(path)
      puts "#{path} file?"
      if path == '/collections'
        false
      else
        true
      end
    end
    
    def directory?(path)
      puts "#{path} file?"
      unless path == '/collections'
        false
      else
        true
      end
    end
    
    def executable?(path)
      puts "executable? #{path}"
      false
    end

    def size(path)
      puts "size #{path}"
      500
    end
    
    def can_delete?(path)
      puts "can_delete? #{path}"
      true
    end
    
    def can_write?(path)
      puts "can_write? #{path}"
      true
    end

    def can_mkdir?(path)
      puts "can_mkdir? #{path}"
      true
    end
    
    def can_rmdir?(path)
      puts "can_rmdir? #{path}"
      true
    end

    def touch(path)
      puts "touch #{path}"
    end
    
    def mkdir(path)
      puts "mkdir #{path}"
    end

    def rmdir(path)
      puts "rmdir #{path}"
    end
    
    def write_to path, body
      puts "write to #{path} - #{body.length}"
    end
    
    def read_file path
      puts "read file #{path}"
      "dummy"
    end
  end
end
