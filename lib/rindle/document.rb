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

      def find_unassociated
        unassociated = []
        Rindle.index.each_pair do |index, path|
          unless Rindle.collections.values.inject(false) { |a, o| a = (a or o['items'].include?(index)) }
            unassociated << Document.new(index)
          end
        end
        unassociated
      end

      def find_by_name name
        # TODO: implement #find_by_name
      end

      def find_by_path path
        # TODO: implement #find_by_path
      end

      def find_by_index index
        # TODO: implement #find_by_index
      end
    end

    attr_accessor :index, :path, :file

    def initialize index, path
      @path = path
      @index = index
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
      @filename ||= File.basename(@path)
    end

    # Renames the document. This also means that the index is changed
    # and the Index-hash is updated.
    def rename new_name
      # TODO: implement renaming method
    end

    # Returns an array of all the collections, this document is in.
    def collections
      # TODO: implement the collection finding method
    end
  end
end
