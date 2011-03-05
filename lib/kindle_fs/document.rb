module Kindle
  class Document    
    def initialize index, filename
      @index = index
      @filename = filename
      @collections = Collections.containing(index)
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
  end
end
