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
        # Determine app name
        @app_name = zipfile.dir.entries('Payload').
          select { |file| file =~ /.app$/ }.
          first
        raise "Unable to determine app name from #{filename}" unless @app_name

        # Find and read Info.plist
        infoplist_entry = zipfile.get_entry("Payload/#{@app_name}/Info.plist")
        infoplist_data = infoplist_entry.get_input_stream.read
        @info_plist = Antenna::InfoPlist.new(infoplist_data)
        raise "Unable to find Info.plist in #{filename}" unless @info_plist
      end
    end

    # Returns icon image data for given pixel size and resolution (defaults to 1).
    def bundle_icon(size, resolution=1)
      icon_data = nil
      if filename = @info_plist.bundle_icons[size][resolution]
        icon_glob = "Payload/#{@app_name}/#{filename}*.png"
        Zip::File.open(@filename) do |zipfile|
          zipfile.glob(icon_glob).each do |icon|
            icon_data = icon.get_input_stream.read
          end
        end
      end
      icon_data
    end

    def input_stream
      File.open(@filename, "r")
    end
  end
end