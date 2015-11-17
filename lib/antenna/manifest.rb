require 'erb'

module Antenna
  class Manifest
    include ERB::Util
    
    attr_accessor :info_plist, :ipa_url, :display_image_url, :need_shine

    def initialize(ipa_url, info_plist, display_image_url)
        @ipa_url, @info_plist, @display_image_url = ipa_url, info_plist, display_image_url
    end

    def template
        <<-EOF
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
    <dict>
        <key>items</key>
        <array>
            <dict>
                <key>assets</key>
                <array>
                    <dict>
                        <key>kind</key>
                        <string>software-package</string>
                        <key>url</key>
                        <string><%= h(@ipa_url) %></string>
                    </dict>
                    <dict>
                        <key>kind</key>
                        <string>display-image</string>
                        <key>needs-shine</key>
                        <false/>
                        <key>url</key>
                        <string><%= h(@display_image_url) %></string>
                    </dict>
                </array>
                <key>metadata</key>
                <dict>
                    <key>bundle-identifier</key>
                    <string><%= @info_plist.bundle_identifier %></string>
                    <key>bundle-version</key>
                    <string><%= @info_plist.bundle_short_version %></string>
                    <key>kind</key>
                    <string>software</string>
                    <key>title</key>
                    <string><%= @info_plist.bundle_display_name %></string>
                </dict>
            </dict>
        </array>
    </dict>
</plist>
EOF
    end

    def to_s
      ERB.new(template).result(binding)
    end
  end
end
