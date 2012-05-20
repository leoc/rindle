require "digest/sha1"

class Rindle
  class Document
    class NotFound < Exception; end

    class << self

      def create filename, options = {}
        doc = Rindle::Document.new filename
        Rindle.index[doc.index] = doc

        absolute_path = File.join(Rindle.root_path, doc.path)
        if options[:data]
          File.open(absolute_path, 'w+') do |f|
            f.write options[:data]
          end
        else
          FileUtils.touch absolute_path
        end

        doc
      end

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

      # Generates the index for the current path
      def generate_index path
        if path =~ /([\w\s]+)-asin_([A-Z0-9]+)-type_([A-Z]+)-v_[0-9]+.azw/
          "##{$2}^#{$3}"
        else
          "*#{Digest::SHA1.hexdigest(File.join('/mnt/us', path))}"
        end
      end
    end

    attr_reader :index, :path

    def initialize path
      path = "/#{File.join('documents', path)}" unless path =~ %r{^/{0,1}documents/}
      path = "/#{path}" unless path =~ %r{^/}
      @path  = path
      @index = Rindle::Document.generate_index(path)
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

      old_index = @index
      old_path = @path.dup
      @path.gsub!(filename, new_name)
      @index = Rindle::Document.generate_index(@path)

      File.rename File.join(Rindle.root_path, old_path),
                  File.join(Rindle.root_path, @path)

      Rindle.collections.values.each do |col|
        if col.include?(old_index)
          col.remove old_index
          col.add @index
        end
      end

      Rindle.index[@index] = self
      true
    end

    def destroy!
      Rindle.collections.values.each do |col|
        col.remove index if col.include? index
      end
      Rindle.index.delete index
    end

    def delete!
      destroy!
      FileUtils.rm_f File.join(Rindle.root_path, path)
    end

    # Returns an array of all the collections, this document is in.
    def collections
      Rindle.collections.values.select do |col|
        col.include? self.index
      end
    end
  end
end
