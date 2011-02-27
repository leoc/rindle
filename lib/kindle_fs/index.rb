module KindleFS
  class Index < Hash
    # loads the index information from the system directory found in the root
    # of the kindles memory. If there is no file to load, it will be created.
    def initialize(kindle_root)
      @kindle_root = kindle_root
    end

    def load
      yield 'loading index', 0.0 if block_given?
      # if index file does not exist create it
      # if it exists load it
      # scan through all documents and update the index
    end
  end
end
