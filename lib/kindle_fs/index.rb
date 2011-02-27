require "rubygems"
require "json"
require "digest/sha1"

def hash(value)
  Digest::SHA1.hexdigest("/mnt/us/#{value}")
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
    def self.update
      Dir["#{@@kindle_root}/documents/*.mobi"].each do |element|
        puts element
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
    
    # creates the file handler for the kindlefs index file
    # if the file did not exists, it is created, otherwise loaded and parsed
    # afterwards the index gets updated and the new new one will be saved
    def self.load(kindle_root)
      @@kindle_root = kindle_root
      if File.exists?(File.join(kindle_root, 'system', 'kindlefs_index.json'))
        @@index_file = File.new(File.join(kindle_root, 'system', 'kindlefs_index.json'))
        @@index = JSON.load(@@index_file)
      else
        @@index_file = File.new(File.join(kindle_root, 'system', 'kindlefs_index.json'), "w+")
        @@index = JSON.parse("{}")
      end
      update
      save
    end
    
    # dumps the index onto the kindle system directory
    def save
      JSON.dump(@@index, @@index_file)
    end
  end
end
