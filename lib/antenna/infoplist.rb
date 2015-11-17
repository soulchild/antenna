require "CFPropertyList"

module Antenna
  class InfoPlist
    attr_accessor :bundle_display_name, :bundle_short_version, :bundle_identifier, :bundle_version, :bundle_icons, :bundle_minimum_os_version

    class << self
      # Class method to instantiate object with data from file.
      def from_file(filename)
        self.new(File.read(filename))
      end

      # Heuristically determines available icon sizes and resolutions from icon filenames
      # and normalizes them into a hash. This hopefully works for most cases out there.
      # Returns a hash of hashes like the following: 
      # { icon_width => { icon_resolution => icon_filename } }
      def determine_icons(iconfiles)
        icons = Hash.new { |h, k| h[k] = { } }
        iconfiles.each { |file| 
          (width, height, resolution) = file.to_s.scan(/(\d+)?x?(\d+)?@?(\d+)?x?(\.png)?$/).flatten
          next unless width
          icons[width.to_i][(resolution || 1).to_i] = File.basename(file, ".*")
        }
        icons
      end
    end

    def initialize(data)
      infoplist = CFPropertyList::List.new(:data => data)
      infoplist_data = CFPropertyList.native_types(infoplist.value)

      @bundle_display_name        = infoplist_data["CFBundleDisplayName"] || infoplist_data["CFBundleName"]
      @bundle_identifier          = infoplist_data["CFBundleIdentifier"]
      @bundle_short_version       = infoplist_data["CFBundleShortVersionString"]
      @bundle_version             = infoplist_data["CFBundleVersion"]
      @bundle_minimum_os_version  = infoplist_data["MinimumOSVersion"]
      @bundle_icons               = {}

      if icons = infoplist_data["CFBundleIconFiles"]
        @bundle_icons = self.class.determine_icons(icons)
      else
        if icons = infoplist_data["CFBundleIcons"]
          if primary_icon = icons["CFBundlePrimaryIcon"]
            @bundle_icons = self.class.determine_icons(primary_icon["CFBundleIconFiles"])
          end
        end
      end
    end
  end
end