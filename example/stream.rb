#!/usr/bin/ruby

require 'vips'

# anything that implements IO::
source = File.open ARGV[0], "rb"
input_stream = Vips::Streamiu.new
input_stream.on_read do |length| 
  puts "read #{length} bytes from source"
  source.read length
end
input_stream.on_seek do |offset, whence| 
  puts "seek offset #{offset}, whence #{whence}"
  source.seek(offset, whence) 
end

dest = File.open ARGV[1], "w"
output_stream = Vips::Streamou.new
output_stream.on_write do |chunk| 
  puts "write #{length} bytes to dest"
  dest.write(chunk)
end
output_stream.on_finish do 
  puts "finish dest"
  dest.close 
end

image = Vips::Image.new_from_stream input_stream, "", access: "sequential"
image.write_to_stream output_stream, ".png"
