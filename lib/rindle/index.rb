# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require "digest/sha1"

module Rindle
  class Index < Hash
    def initialize
      @index = {}
    end

    def self.load(root_path)
      Index.new.load(root_path)
    end

    def load(root_path)
      @root_path = root_path
      documents = Dir[File.join(@root_path, '{documents,pictures}', '*.{mobi,azw,azw1,pdf,rtf}')]
      documents.each do |element|
        add(element.gsub(@root_path, ''))
      end
      self
    end

    def hash(value)
      Digest::SHA1.hexdigest(File.join('/mnt/us', value))
    end

    # Adds a path to the index. This means that the correct sha1 sum
    # is generated and used as index for the newly created document
    # object.
    def add path
      if path =~ /([\w\s]+)-asin_([A-Z0-9]+)-type_([A-Z]+)-v_[0-9]+.azw/
        # it's a kindle store document, with a special naming
        index = "##{$2}^#{$3}"
      else
        # it's a non-amazon document
        index = "*#{hash(path)}"
      end
      self[index] = Document.new index, path
      index
    end

    # Removes either an entry either by `Document` or index.
    def remove obj
      if obj.is_a?(Document)
        delete(index(obj))
      else
        delete(obj)
      end
    end

  end
end
