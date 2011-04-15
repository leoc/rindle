require 'fusefs'

module Rindle
  class Filesystem < FuseFS::FuseDir
    COLLECTION_NAME  = /([A-Za-z0-9_\-\s'"]+)/i
    DOCUMENT_NAME    = /([A-Za-z0-9_\s]+\.[mobi|epub|rtf|pdf]+)/i
    DOCUMENT_PATH    = /^\/collections\/#{COLLECTION_NAME}\/#{DOCUMENT_NAME}$/
    COLLECTION_PATH  = /^\/collections\/#{COLLECTION_NAME}$/
    
    def contents path
      puts "contents(#{path})"
      case path
      when /^\/$/ then [ 'collections', 'books', 'pictures' ]
      when /^\/collections$/ then Collection.all.map(&:name)
      when /^\/documents$/ then []
      when /^\/pictures$/ then []
      when COLLECTION_PATH
        collection = Collection.find(:first, :named => $1)
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
      when DOCUMENT_PATH then true
      else false
      end
    rescue Exception => e
      puts e.inspect
      puts e.backtrace
    end
    
    def directory?(path)
      puts "directory?(#{path})"
      case path
      when /^\/[collections|books|pictures]$/ then true
      when COLLECTION_PATH then !Collection.first(:named => $1).nil?
      else false
      end
      #true
    rescue Exception => e
      puts e.inspect
      puts e.backtrace
    end
    
    def executable?(path)
      false
    end

    def size(path)
      puts "size(#{path})"
      1
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
      true
    end

    def rmdir(path)
      puts "rmdir(#{path})"
      true
    end
    
    def write_to path, body
      puts "write_to(#{path}, #{body.length})"
    rescue Exception => e
      puts e.inspect
      puts e.backtrace
    end
    
    def read_file path
      puts "read_file(#{path})"
      "dummy"
    rescue Exceptions => e
      puts e.inspect
      puts e.backtrace
    end
  end
end
