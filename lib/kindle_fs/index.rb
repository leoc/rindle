# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require "digest/sha1"

def hash(value)
  Digest::SHA1.hexdigest(File.join('/mnt/us', value))
end

module KindleFS
  class Index < Hash
    # returns the path for an index
    def self.path_for(index)
      @@index[index]
    end
    
    # returns the index for a file path
    def self.index_for(path)
      @@index.index(path)
    end

    # search a index, filepath pair via regular expression
    def self.search(regexp)
      @@index
      [ index, name ]
    end
    
    # scans through all the documents on the kindle
    # adds indices or removes if necessary
    def self.update
      # add new ones
      documents = Dir[File.join(@@kindle_root, '{documents,pictures}', '*.{mobi,azw,pdf}')]
      documents.map! do |element|
        element.gsub(@@kindle_root, '')
      end
      documents.each do |element|
        add(element)
      end
      # remove deleted ones
      @@index = @@index.delete_if do |index,path|
        !File.exists?(File.join(@@kindle_root, path))
      end
    end
    
    # adds a path to the index, while automatically creating the sha1 hash
    def self.add(path)
      if path =~ /([\w\s]+)-asin_([A-Z0-9]+)-type_([A-Z]+)-v_[0-9]+.azw/
        # it's a kindle book store doc
        # we have to build the index ourselves
        index = "##{$2}^#{$3}"
      else
        # it's a document not from the kindle book store
        index = "*#{hash(path)}"
      end      
      @@index[index] = path
      index
    end

    # removes a value from the index
    def self.remove(value)
      if @@index[value].nil?
        @@index.delete(@@index.index(value))
      else
        @@index.delete(value)
      end
    end
    
    # loads the index file from the kindles system directory
    # if it does not exist, an empty hash will be loaded and the index will be updated accordingly
    def self.load(kindle_root)
      @@kindle_root = kindle_root
      begin
        file = File.new(File.join(@@kindle_root, 'system', 'kindlefs_index.json'), 'r')
        @@index = JSON.load(file)
        file.close
      rescue Exception => e
        @@index = JSON.parse("{}")
      end
      update
      save
    end
    
    # dumps the index onto the kindle system directory
    def self.save
      file = File.new(File.join(@@kindle_root, 'system', 'kindlefs_index.json'), 'w+')
      JSON.dump(@@index, file)
      file.close
    end
  end
end
