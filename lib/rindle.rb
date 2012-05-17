require 'rindle/version'
require 'rindle/index'
require 'rindle/collections'
require 'rindle/collection'
require 'rindle/document'

require 'rindle/mixins/regexp'

# This module is used to load the Kindles state into the
# data structures, which are used to let you access the Kindles
# content in a way, that reminds one of the ActiveRecord usage
#
# Load from a specific path
#
#   Rindle.load(path)
#
# After that you may use the models Collection, Document, Album
module Rindle
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
    @@index = Index.load(root_path)
    @@collections = Collections.load(root_path)
  end

  def self.save
    @@collections.save
  end
end
