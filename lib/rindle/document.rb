module Rindle
  class Document
    class NotFound < Exception; end

    class << self
      def all options = {}
        filtered = []
        Rindle.index.each_pair do |index, path|
          match = true
          filename = File.basename(path)
          options.each_pair do |key, value|
            case key
            when :named
              match = match && filename =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            when :indexed
              match = match && index =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            end
          end
          filtered << Document.new(index) if match
        end
        filtered
      end

      def first options = {}
        Rindle.index.each_pair do |index, path|
          match = true
          filename = File.basename(path)
          options.each_pair do |key, value|
            case key
            when :named
              match = match && filename =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            when :indexed
              match = match && index =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            end
          end
          return Document.new(index) if match
        end
        nil
      end

      def find method = :all, options = {}
        self.send method, options
      end
    end

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
