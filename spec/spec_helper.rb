$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'kindle_fs'

require 'rubygems'
require 'rspec'

kindle_root = File.join(File.dirname(__FILE__), 'data', 'kindle')

Rspec.configure do |config|
  # give me something to do!
end
