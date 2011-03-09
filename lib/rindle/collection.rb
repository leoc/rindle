module Rindle
  class Collection
    attr_accessor :name, :indices , :last_access

    def == other
      name == other.name && indices == other.indices && last_access == other.last_access
    end
    
    def initialize(name, indices, last_access = nil)
      @name = name
      @indices = indices
      @last_access = last_access.nil? ? Time.now : Time.at(last_access)
    end

    def self.all options={}
      filtered = []
      Rindle.collections.each_pair do |name, collection|
        match = true
        options.each_pair do |key,value|
          case key
          when :named
            match = match && name =~ /#{value}/
          when :including
            if value.is_a?(Array)
              match = !(match && collection['items'] & value).empty?
            else
              match = match && collection['items'].include?(value)
            end
          when :accessed
            match = match && value == collection['lastAccess']
          end
        end
        filtered << Collection.new(name.sub('@en-US',''), collection['items'], collection['lastAccess']) if match
      end
      filtered
    end
    
    def self.first options={}
      find(:first)
    end
    
    def self.find(method = :all, options={})
      self.send method, options
    end
    
    def to_hash
      {
        "#{@name}@en-US" => {
          "items" => @indices,
          "lastAccess" => @last_access.to_i
        }
      }
    end

    def self.create name, indices
      collection = Collection.new(name, indices)
      Rindle.collections.merge(collection.to_hash)
      collection
    end
    
    def touch
      last_access = Time.now
    end
  end
end
