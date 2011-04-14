module Rindle
  class Document
    class NotFound < Exception; end
    
    attr_accessor :index, :path, :file
    
    def initialize index
      @path = Rindle.index[index]
      raise NotFound, "Index #{index} not found!" if @path.nil?
      @index = index
    end

    def == other
      @index == other.index 
    end
    
    def self.by value
      if value.is_a?(RegExp)
        index, name = Index.search(value)
      else
        index = Index.index_for(name)
        index, name = value, Index.name_for(value)
      end
      File.new(index, name)
    end
    
    def filename
      File.basename(@path)
    end

  end
end
