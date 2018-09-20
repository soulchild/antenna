$:.push File.expand_path('../', __FILE__)

require 'command/s3'
require 'command/local'

private

def determine_file!
  files = Dir['*.ipa']
  @file ||= case files.length
            when 0 then nil
            when 1 then files.first
            else
              @file = choose "Select an .ipa File:", *files
            end
  puts "Found ipa file #{@file}" if @file
end