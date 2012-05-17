require "digest/sha1"

module Rindle
  class Document
    class NotFound < Exception; end

    class << self
      def all options = {}
        filtered = []
        Rindle.index.each_pair do |index, doc|
          match = true
          options.each_pair do |key, value|
            case key
            when :named
              match = match && doc.filename =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            when :indexed
              match = match && index =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            end
          end
          filtered << doc if match
        end
        filtered
      end

      def first options = {}
        Rindle.index.each_pair do |index, doc|
          match = true
          options.each_pair do |key, value|
            case key
            when :named
              match = match && doc.filename =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            when :indexed
              match = match && index =~ /#{value.is_a?(String) ? Regexp.escape(value) : value}/
            end
          end
          return doc if match
        end
        nil
      end

      def find method = :all, options = {}
        self.send method, options
      end

      def unassociated
        unassociated = []
        Rindle.index.each_pair do |index, doc|
          unless Rindle.collections.values.inject(false) { |acc, col| acc = acc or col.include?(index) }
            unassociated << doc
          end
        end
        unassociated
      end

      def find_by_name name
        Rindle.index.values.each do |doc|
          return doc if doc.filename =~ /#{name.is_a?(String) ? Regexp.escape(name) : name}/
        end
        nil
      end

      def find_by_path path
        Rindle.index.values.each do |doc|
          return doc if doc.path =~ /#{path.is_a?(String) ? Regexp.escape(path) : path}/
        end
        nil
      end

      def find_by_index index
        Rindle.index[index]
      end
    end

    attr_reader :index, :path

    def initialize path
      self.path = path
    end

    # Sets the path variable and updates the index
    def path= path
      @path  = path
      @index = generate_index
    end

    # Generates the index for the current path
    def generate_index
      if path =~ /([\w\s]+)-asin_([A-Z0-9]+)-type_([A-Z]+)-v_[0-9]+.azw/
        "##{$2}^#{$3}"
      else
        "*#{Digest::SHA1.hexdigest(File.join('/mnt/us', path))}"
      end
    end

    # Two documents are the same if the indices are equal.
    def == other
      @index == other.index
    end

    # Returns the filesize of this document.
    def filesize
      @filesize ||= File.size(File.join(Rindle.root_path, @path))
    end

    # Returns the filename of this document.
    def filename
      File.basename(@path)
    end

    # Returns true if the `path` looks like an amazon kindle store file.
    def amazon?
      !(path !~ /([\w\s]+)-asin_([A-Z0-9]+)-type_([A-Z]+)-v_[0-9]+.azw/)
    end

    # Renames the document. This also means that the index is changed
    # and the Index-hash is updated.
    def rename! new_name
      Rindle.index.delete(@index)
      self.path = @path.gsub filename, new_name
      # TODO: update references in Rindle.collections
      Rindle.index[@index] = self
    end

    # Returns an array of all the collections, this document is in.
    def collections
      Rindle.collections.select do |col|
        col.include? self.index
      end
    end
  end
end
