require 'kindle_fs/index'
require 'kindle_fs/collections'
require 'kindle_fs/collection'
require 'kindle_fs/document'
require 'kindle_fs/filesystem'

# This module is used to load the Kindles state into the
# data structures, which are used to let you access the Kindles
# content in a way, that reminds one of the ActiveRecord usage
#
# Load from a specific path
#
#   Kindle.load(path)
#
# After that you may use the models Collection, Document, Album
module Kindle  
  @@root_path = nil
  @@collections = nil
  @@index = nil
  
  class NotLoaded < Exception; end
  
  def self.root_path
    if @@root_path
      @@root_path
    else
      raise NotLoaded
    end
  end

  def self.index
    if @@index
      @@index
    else
      raise NotLoaded
    end
  end

  def self.collections
    if @@collections
      @@collections
    else
      raise NotLoaded
    end
  end
  
  def self.load root_path
    @@root_path = root_path
    @@index = Index.new(root_path)
    @@collections = Collections.new(root_path)
  end
end
