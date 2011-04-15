require 'fusefs'

module Rindle
  class Filesystem < FuseFS::FuseDir

    def contents path
      puts "contents(#{path})"
      case path
      when /^\/$$/
        [ 'collections', 'books', 'pictures' ]
      when /^\/collections$/
        Collection.all.map(&:name)
      when /^\/documents$/
        [ 'not_yet_implemented' ]
      when /^\/pictures$/
        [ 'not_yet_implemented' ]
      when /^\/collections\/(\._)?([A-Za-z0-9_\-\s'"]+)$/
        collection = Collection.find(:first, :named => $3)
        collection.documents.map(&:filename)
      else
        []
      end
    rescue Exception => e
      puts e.inspect
      puts e.backtrace
    end
    
    def file?(path)
      puts "file?(#{path})"
      case path
      when /^\/(collections|books|pictures)$/
        false
      when /^\/collections\/(\._)?([A-Za-z0-9_\-\s'"]+)$/
        false
      else
        false
      end
    end
    
    def directory?(path)
      puts "directory?(#{path})"
      case path
      when /^\/[collections|books|pictures]$/
        true
      when /^\/collections\/(\._)?([A-Za-z0-9_\-\s'"]+)$/
        !Collection.first(:named => $3).nil?
      else
        false
      end
    end
    
    def executable?(path)
      false
    end

    def size(path)
      puts "size(#{path})"
      0
    end
    
    def can_delete?(path)
      puts "can_delete?(#{path})"
      true
    end
    
    def can_write?(path)
      puts "can_write?(#{path})"
      true
    end

    def can_mkdir?(path)
      puts "can_mkdir?(#{path})"
      true
    end
    
    def can_rmdir?(path)
      puts "can_rmdir?(#{path})"
      true
    end

    def touch(path)
      puts "touch(#{path})"
    end
    
    def mkdir(path)
      puts "mkdir(#{path})"
      false
    end

    def rmdir(path)
      puts "rmdir(#{path})"
      false
    end
    
    def write_to path, body
      puts "write_to(#{path}, #{body.length})"
    end
    
    def read_file path
      puts "read_file(#{path})"
      "dummy"
    rescue Exceptions => e
      puts e.inspect
    end
  end
end
