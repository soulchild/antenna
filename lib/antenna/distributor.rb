require 'antenna/ipa'
require 'antenna/manifest'
require 'antenna/html'

module Antenna
  module Distributor
    def distribute(ipa_file, options = {})
      ipa = process_ipa(ipa_file)
      ipa_url = distribute_ipa(ipa, options)

      app_icon = process_app_icon(ipa)
      app_icon_url = distribute_app_icon(app_icon, options) if app_icon

      manifest = process_manifest(ipa, ipa_url, app_icon_url)
      manifest_url = distribute_manifest(manifest, options)

      html = process_html(ipa, manifest_url, app_icon_url)
      html_url = distribute_html(html, options)

      return html_url
    end

    def process_ipa(ipa_file)
      Antenna::IPA.new(ipa_file)
    end

    def process_app_icon(ipa)
    end

    def process_manifest(ipa, ipa_url, app_icon_url)
      Antenna::Manifest.new(ipa_url, ipa.info_plist, app_icon_url)
    end

    def process_html(ipa, manifest_url, app_icon_url)
      Antenna::HTML.new(ipa.info_plist, manifest_url, app_icon_url)
    end
  end
end