module Kindle
  class Collection < Hash
    attr_accessor :name, :indices, :last_access
    
    def initialize(name, content)
      @name = name
      @indices = content['items']
      @last_access = content['lastAccess']
      # stuff all that from hash into 
    end

    # a more rails'ish versions to retrieve all collections
    def self.all
      Collections.data.keys.map do |name|
        name.gsub('@en-US', '')
      end
    end
    
    # finds a collection by name
    def self.find name
      Collections["#{name}@en-US"]
    end
    
    # create a new collections
    # items may be declared via the options parameter
    def self.create name, options = {}
      options = { 'items' => [], 'lastAccess' => Time.now.to_i }.merge(options)
      Collections["#{name}@en-US"] = Collection.new.merge(options) unless exists?(name)
    end
    
    # renames a collection statically
    def self.rename old, new
      @collections["#{new}@en-US"] = @collections.delete("#{old}@en-US")
    end

    # renames the instantiated collection
    def rename new
      Collections["#{new}@en-US"] = Collections.delete(Collections.index("#{old}@en-US"))
    end

    # checks whether a collection exists or not
    def exists? 
      !Collections["#{name}@en-US"].nil?  
    end

    # adds an item to the items list
    # if the given argument is an index, it's just added
    # otherwise it's looked up in the index
    def add item
      if Index.lookup(item).nil?
        item = Index.index_for(item)
      end
      self['items'] << item
    end
    
    # returns the list of indices, contained by the collection
    def items
      self['items']
    end
    
    # returns a list of filenames for the indices in the collections.json
    def itemnames
      names = self['items'].map do |index|
        path = Index.path_for(index)
        if path
          File.basename(path)
        else
          puts "missing index entry '#{index}'"
          nil
        end
      end
      names.compact
    end
    
    # returns a DateTime of the last access of the collection
    def last_access
      Time.at(self['lastAccess']).to_datetime
    end
    
    # updates the last access timestamp
    def touch
      self['lastAccess'] = Time.now.to_i
    end
  end
end
