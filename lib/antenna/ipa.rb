require "zip"
require "zip/filesystem"

require "antenna/infoplist"

module Antenna
  class IPA
    attr_accessor :filename, :app_name, :info_plist, :bundle_icon_files

    def initialize(filename)
      @filename = filename
      @bundle_icon_files = {}

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

        # Extract main icon files
        @info_plist.bundle_icon_filenames.each do |icon|
          icon_glob = "Payload/#{@app_name}/#{icon}*.png"
          zipfile.glob(icon_glob).each do |entry|
            (width, height, resolution) = entry.to_s.scan(/(\d+)x(\d+)@(\d+)x\.png$/).flatten
            if width and height and resolution
              key = "#{width}x#{height}@#{resolution}x"
              @bundle_icon_files[key] = entry.get_input_stream.read
            end
          end
        end
      end
    end
  end
end