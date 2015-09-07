require "zip"
require "zip/filesystem"

require "antenna/infoplist"

module Antenna
  class IPA
    attr_accessor :filename, :app_name, :info_plist

    def initialize(filename)
      @filename = filename

      Zip::File.open(filename) do |zipfile|
        zipfile.dir.entries("Payload").each do |entry|
          # Find app name
          if entry =~ /.app$/
            app_entry = zipfile.find_entry("Payload/#{entry}")
            if app_entry
              @app_name = entry

              # Find and parse Info.plist
              infoplist_entry = zipfile.find_entry("Payload/#{@app_name}/Info.plist")
              if infoplist_entry
                infoplist_data = infoplist_entry.get_input_stream.read
                @info_plist = Antenna::InfoPlist.new(infoplist_data)
                break
              end
            end
          end
        end

        say "Info.plist not found in #{filename}" and abort unless @info_plist
      end
    end
  end
end