require "CFPropertyList"

module Antenna
  class InfoPlist
    attr_accessor :bundle_display_name, :bundle_short_version, :bundle_identifier, :bundle_version, :bundle_icon_filenames, :bundle_minimum_os_version

    def initialize(data)
      infoplist = CFPropertyList::List.new(
        :data   => data, 
      )
      infoplist_data = CFPropertyList.native_types(infoplist.value)

      @bundle_display_name        = infoplist_data["CFBundleDisplayName"] || infoplist_data["CFBundleName"]
      @bundle_identifier          = infoplist_data["CFBundleIdentifier"]
      @bundle_short_version       = infoplist_data["CFBundleShortVersionString"]
      @bundle_version             = infoplist_data["CFBundleVersion"]
      @bundle_minimum_os_version  = infoplist_data["MinimumOSVersion"]

      icons = infoplist_data["CFBundleIcons"]
      if icons
        primary_icon = icons["CFBundlePrimaryIcon"]
        if primary_icon
          @bundle_icon_filenames = primary_icon["CFBundleIconFiles"]
        end
      end
    end
  end
end