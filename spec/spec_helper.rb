$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'kindle_fs'

require 'rubygems'
require 'rspec'

def kindle_root; File.join(File.dirname(__FILE__), 'data', 'kindle'); end

# this is to reset the Singleton'ish nature of the Kindle module
module Kindle
  def self.reset
    self.class_variables.each do |var|
      eval("#{var} = nil")
    end
  end
end

Rspec.configure do |config|
  # give me something to do!
end
