# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require "digest/sha1"

module Kindle
  class Index < Hash
    def initialize
      @index = {}
    end
        
    def self.load(root_path)
      Index.new.load(root_path)
    end

    def load(root_path)
      @root_path = root_path
      documents = Dir[File.join(@root_path, '{documents,pictures}', '*.{mobi,azw,azw1,pdf}')]
      documents.each do |element|
        add(element.gsub(@root_path, ''))
      end
      self
    end
    
    def hash(value)
      Digest::SHA1.hexdigest(File.join('/mnt/us', value))
    end
    
    def add(path)
      if path =~ /([\w\s]+)-asin_([A-Z0-9]+)-type_([A-Z]+)-v_[0-9]+.azw/
        # (it's a kindle store document, with a special naming)
        index = "##{$2}^#{$3}"
      else
        # (it's a non-amazon document)
        index = "*#{hash(path)}"
      end      
      self[index] = path
      index
    end
    
    # removes either a path or an index
    def remove(value)
      if self[value].nil?
        delete(index(value))
      else
        delete(value)
      end
    end
    
    def save
      File.open(File.join(@root_path, 'system', 'kindlefs_index.json'), 'w+') do |file|
        JSON.dump(self, file)
      end
    end
  end
end
