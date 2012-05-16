module Rindle
  class Collection
    class << self
      def all options = {}
        filtered = []
        Rindle.collections.each_pair do |name, collection|
          match = true
          options.each_pair do |key,value|
            case key
            when :named
              match = match && name =~ /#{value}/
            when :including
              match = match && collection.include?(value)
            when :accessed
              time = value.is_a?(Integer) ? Time.at(value) : value
              match = match && collection.last_access == time
            end
          end
          filtered << collection if match
        end
        filtered
      end

      def first options = {}
        Rindle.collections.each_pair do |name, collection|
          match = true
          options.each_pair do |key,value|
            case key
            when :named
              match = match && collection.name =~ /#{value}/
            when :including
              match = match && collection.include?(value)
            when :accessed
              time = value.is_a?(Integer) ? Time.at(value) : value
              match = match && collection.last_access == time
            end
          end
          return collection if match
        end
        nil
      end

      def find(method = :all, options={})
        self.send method, options
      end

      def find_by_name name
        find(:first, :named => name)
      end

      def create name, options = {}
        collection = Collection.new(name, options)
        Rindle.collections[collection.name] = collection
      end

      def exists? options
        !Collection.first(options).nil?
      end
    end

    attr_reader :name, :indices, :last_access

    def == other
      other.is_a?(Rindle::Collection) &&
        name == other.name &&
        indices == other.indices &&
        last_access == other.last_access
    end

    def initialize name, options = {}
      { :indices => [], :last_access => nil }.merge!(options)
      @name = name.gsub('@en-US', '')
      @indices = options[:indices] || []
      @last_access = Time.at(options[:last_access]) if options[:last_access]
    end

    # Returns a hash that may be saved to `collections.json` file.
    def to_hash
      {
        "#{@name}@en-US" => {
          "items" => @indices,
          "lastAccess" => @last_access.to_i
        }
      }
    end

    # Renames the collection. This changes the collections name and
    # updates the Collections hash.
    def rename! new_name
      Rindle.collections.delete @name
      @name = new_name
      Rindle.collections[@name] = self
    end

    # Destroys the collection. This removes the collections key from
    # the collections hash.
    def destroy!
      Rindle.collections.delete @name
    end

    # Adds an index or a document to the collection.
    def add index
      index = index.index if index.is_a?(Document)
      unless indices.include?(index)
        indices << obj.index
        @documents = nil
      end
    end

    # Removes an entry from this collection.
    def remove index
      index = index.index if index.is_a?(Document)
      if indices.include?(index)
        indices.delete index
        @documents = nil
      end
    end

    # Sets the indices array and resets the documents memoized array
    # of `Document` objects.
    def indices= indices
      @documents = nil
      @indices = indices
    end

    # Returns an `Array` of `Document` objects.
    def documents
      @documents ||= @indices.map { |i| Rindle.index[i] }
    end

    # Sets the array of `Document` objects.
    def documents= documents
      indices = documents.map(&:index)
      @documents = documents
    end

    # Returns true if the collection includes the given indec,
    # `Document` or `Array`.
    def include? obj
      if obj.is_a?(Array)
        obj.inject(true) { |acc, o| acc = acc and include?(o) }
      elsif obj.is_a?(Document)
        indices.include? obj.index
      elsif obj.is_a?(String)
        indices.include? obj
      else
        false
      end
    end

    # Update the last access timestamp.
    def touch
      last_access = Time.now
    end
  end
end
