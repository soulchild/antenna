require 'erb'

module Antenna
  class HTML
    include ERB::Util
  
    attr_accessor :info_plist, :manifest_url, :display_image_url, :need_shine

    def initialize(info_plist, manifest_url, display_image_url)
        @info_plist, @manifest_url, @display_image_url = info_plist, manifest_url, display_image_url
    end

    def template
      <<-EOF
<!doctype html>
<html>
<head>
    <title><%= @info_plist.bundle_display_name %> v<%= @info_plist.bundle_short_version %> (<%= @info_plist.bundle_version %>)</title>
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no">
    <style type="text/css">
        body { font-family: Helvetica, Arial, sans-serif; text-align: center; color: #444; font-size: 18px; }
        img { display: block; margin: 1em auto; border: none; width: 120px; height: 120px; }
    </style>
</head>
<body>
    <h1><%= @info_plist.bundle_display_name %></h1>
    <h2><%= @info_plist.bundle_short_version %> (<%= @info_plist.bundle_version %>)</h2>
    <a href="itms-services://?action=download-manifest&amp;url=<%= u(@manifest_url) %>"><img src="<%= @display_image_url %>">Installieren</a>
</body>
</html>
EOF
    end

    def to_s
      ERB.new(template).result(binding)
    end
  end
end