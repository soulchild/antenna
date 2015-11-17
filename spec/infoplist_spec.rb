require 'spec_helper'
require 'antenna/infoplist'

describe Antenna::InfoPlist do 
    before(:example, :legacy => true) do
      @infoplist = Antenna::InfoPlist.from_file("spec/data/Info-Legacy.plist")
    end

    before(:example, :legacy => false) do
      @infoplist = Antenna::InfoPlist.from_file("spec/data/Info.plist")
    end

  describe "#initialize" do
    context "with current Info.plist", :legacy => false do
      it "should parse infoplist" do
        expect(@infoplist.bundle_display_name).to eq("OverTheAir")
        expect(@infoplist.bundle_identifier).to eq("de.funkreich.OverTheAir")
        expect(@infoplist.bundle_short_version).to eq("1.0")
        expect(@infoplist.bundle_version).to eq("1337")
        expect(@infoplist.bundle_minimum_os_version).to eq("8.0")
      end
    end

    context "with legacy Info.plist", :legacy => true do
      it "should parse infoplist" do
        expect(@infoplist.bundle_display_name).to eq("OverTheAir")
        expect(@infoplist.bundle_identifier).to eq("de.funkreich.OverTheAir")
        expect(@infoplist.bundle_short_version).to eq("1.0")
        expect(@infoplist.bundle_version).to eq("1337")
        expect(@infoplist.bundle_minimum_os_version).to eq(nil)
      end
    end
  end

  describe "#bundle_icon_filenames" do
    context "with current Info.plist", :legacy => false do
      it "should extract bundle icons" do
        expect(@infoplist.bundle_icons).to eq( { 60 => { 1 => "AppIcon60x60" } } )
      end
    end

    context "with legacy Info.plist", :legacy => true do
      it "should extract bundle icons" do
        expected_hash = {60=>{1=>"AppIcon60x60", 2=>"AppIcon60x60@2x"}, 72=>{1=>"Icon-72", 2=>"Icon-72@2x"}, 76=>{1=>"Icon-76", 2=>"Icon-76@2x"}, 50=>{1=>"Icon-Small-50", 2=>"Icon-Small-50@2x"}, 40=>{1=>"Icon-Spotlight-40", 2=>"Icon-Spotlight-40@2x"}}
        expect(@infoplist.bundle_icons).to eq(expected_hash)
      end
    end
  end

  # describe "#parse_icons" do
  #   it "should parse icon filenames" do
  #     iconfiles = ["Icon.png", "AppIcon60x60", "AppIcon60x60@2x", "Icon@2x.png", "Icon-72.png", "Icon-72@2x.png", "Icon-76.png", "Icon-76@2x.png", "Icon-Small-50.png", "Icon-Small-50@2x.png", "Icon-Spotlight-40.png", "Icon-Spotlight-40@2x.png", "Icon-Small.png", "Icon-Small@2x.png" ]
  #     expected_hash = {"60"=>{1=>"AppIcon60x60", "2"=>"AppIcon60x60@2x"}, "72"=>{1=>"Icon-72", "2"=>"Icon-72@2x"}, "76"=>{1=>"Icon-76", "2"=>"Icon-76@2x"}, "50"=>{1=>"Icon-Small-50", "2"=>"Icon-Small-50@2x"}, "40"=>{1=>"Icon-Spotlight-40", "2"=>"Icon-Spotlight-40@2x"}}
  #     parsed_icons = Antenna::InfoPlist.parse_icons(iconfiles)
  #     expect(parsed_icons).to eq(expected_hash)
  #   end
  # end
end