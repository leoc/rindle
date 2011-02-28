# -*- coding: utf-8 -*-
require "rubygems"
require "json"
require "digest/sha1"

def hash(value)
  Digest::SHA1.hexdigest(value)
end

module KindleFS
  class Index < Hash
    # returns the path for an index
    def self.name_for(index)
      @@index[index]
    end
    
    # returns the index for a file path
    def self.index_for(name)
      @@index.index(name)
    end

    # search a index, filepath pair via regular expression
    def self.search(regexp)
      @@index
      [ index, name ]
    end
    
    # scans through all the documents on the kindle
    # adds indices or removes if necessary
    # TODO: handle pictures aswell
    def self.update
      documents = Dir[File.join(@@kindle_root, '{documents,pictures}', '*.{mobi,azw,pdf}')]
      documents.map! do |element|
        element.gsub(@@kindle_root, '/mnt/us')
      end
      documents.each do |element|
        add(element)
      end
    end
    
    # adds a filename to the index, while automatically creating the sha1 hash
    # TODO: handle the amazon kindle book store filenames specially
    def self.add(filename)
      index = hash(filename)
      @@index[index] = filename
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
      @@kindle_root = kindle_root.sub(/#{Regexp.escape(File::SEPARATOR)}$/, '')
      begin
        file = File.new(File.join(@@kindle_root, 'system', 'kindlefs_index.json'), 'r')
        @@index = JSON.load(file)
        file.close
      rescue Exception => e
        @@index = JSON.parse("{}")
      end
      update
      puts @@index.inspect
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
