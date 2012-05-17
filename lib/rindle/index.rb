# -*- coding: utf-8 -*-
require "rubygems"
require "json"

class Rindle
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

    # Adds a path to the index. This means that the correct sha1 sum
    # is generated and used as index for the newly created document
    # object.
    def add path
      doc = Document.new path
      self[doc.index] = doc
      doc.index
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
