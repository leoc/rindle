require 'rubygems'
require 'fusefs'

require 'kindle_fs/index'
require 'kindle_fs/collections'
require 'kindle_fs/filesystem'

if ARGV.length < 1
  puts "usage: kindle_manager <kindle_root> <mount_point>"
  exit 1
end

trap("INT") do
  puts "exiting kindlefs ..."
  FuseFS.exit
  FuseFS.unmount
  exit
end

kindle_root = ARGV.shift.sub(/#{Regexp.escape(File::SEPARATOR)}$/, '')
mount_path = ARGV.shift.sub(/#{Regexp.escape(File::SEPARATOR)}$/, '')

KindleFS::Index.load(kindle_root)
KindleFS::Collections.load(kindle_root)

kindle = KindleFS::Filesystem.new(kindle_root)
FuseFS.set_root(kindle)
FuseFS.mount_under mount_path
FuseFS.run
