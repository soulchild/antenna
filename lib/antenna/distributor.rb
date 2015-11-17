require 'antenna/ipa'
require 'antenna/manifest'
require 'antenna/html'

module Antenna
  class Distributor
    def initialize(distributor)
      @distributor = distributor
    end

    def distribute(ipa_file, options = {})
      base_filename = options[:base] || File.basename(ipa_file, ".ipa")

      # Let distributor set things up (if necessary)
      @distributor.setup(ipa_file, options) if @distributor.respond_to?(:setup)

      # Distribute IPA
      ipa = process_ipa(ipa_file)
      ipa_url = @distributor.distribute(
        ipa.input_stream.read,
        "#{base_filename}.ipa",
        "application/octet-stream",
      )

      # Distribute App Icon
      if app_icon = process_app_icon(ipa)
        app_icon_url = @distributor.distribute(
          app_icon,
          "#{base_filename}.png",
          "image/png",
        ) 
      end

      # Distribute Manifest
      manifest = build_manifest(ipa, ipa_url, app_icon_url)
      manifest_url = @distributor.distribute(
        manifest.to_s,
        "#{base_filename}.plist",
        "text/xml",
      )
      
      # Distribute HTML
      html = build_html(ipa, manifest_url, app_icon_url)
      html_url = @distributor.distribute(
        html.to_s,
        "#{base_filename}.html",
        "text/html",
      )

      # Let distributor clean things up (if necessary)
      @distributor.teardown if @distributor.respond_to?(:teardown)

      return html_url
    end

    private

    def process_ipa(ipa_file)
      Antenna::IPA.new(ipa_file)
    end

    def process_app_icon(ipa)
      ipa.bundle_icon(57, 2) || ipa.bundle_icon(57, 1) || ipa.bundle_icon(60, 2) || ipa.bundle_icon(60, 1)
    end

    def build_manifest(ipa, ipa_url, app_icon_url)
      Antenna::Manifest.new(ipa_url, ipa.info_plist, app_icon_url)
    end

    def build_html(ipa, manifest_url, app_icon_url)
      Antenna::HTML.new(ipa.info_plist, manifest_url, app_icon_url)
    end
  end
end