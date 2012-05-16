module Rindle
  class Collection
    class << self
      def all options={}
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

      def first options={}
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
          return Collection.new(name.sub('@en-US',''), collection['items'], collection['lastAccess']) if match
        end
        nil
      end

      def find(method = :all, options={})
        self.send method, options
      end

      def create name, options = {}
        collection = Collection.new(name, options)
        Rindle.collections[collection.name] = collection
      end

      def exists? options
        !Collection.first(options).nil?
      end
    end

    attr_reader :name, :indices

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

    def to_hash
      {
        "#{@name}@en-US" => {
          "items" => @indices,
          "lastAccess" => @last_access.to_i
        }
      }
    end

    def rename! new_name
      Rindle.collections.delete "#{@name}@en-US"
      @name = new_name
      Rindle.collections.merge!(to_hash)
    end

    def destroy!
      Rindle.collections.delete "#{@name}@en-US"
    end

    def add obj
      if obj
    end

    # Removes an entry from this collection.
    def remove obj
      @documents = nil
      if obj.is_a?(Document)
        indices.delete obj.index
      else
        indices.delete obj
      end
    end

    def indices= indices
      @documents = nil
      @indices = indices
    end

    # Returns an `Array` of `Document` objects.
    def documents
      @documents ||= @indices.map { |i| Rindle.index[i] }
    end

    # Sets the
    def documents= documents
      indices = documents.map(&:index)
    end

    def touch
      last_access = Time.now
    end
  end
end
