require 'rubygems'
require 'fusefs'

require 'kindle_fs/index'
require 'kindle_fs/collections'

if ARGV.length < 1
  puts "usage: kindle_manager <kindle_root>"
  exit 1
end

kindle_root = ARGV[0]

index = KindleFS::Index.new(kindle_root)
index.load do |job, percentage|
  puts "#{job} - #{percentage}"
end
collections = KindleFS::Collections.new(kindle_root)
collections.load do |job, percentage|
  puts "#{job} #{percentage}"
end

kindle = KindleFS.new(kindle_root, collections, index)
FuseFS.set_root( kindle )

# Mount under a directory given on the command line.
FuseFS.mount_under ARGV.shift
FuseFS.run

