# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'antenna/version'

Gem::Specification.new do |spec|
  spec.name          = "antenna-ota"
  spec.version       = Antenna::VERSION
  spec.authors       = ["Tobi Kremer"]
  spec.email         = ["tobias.kremer@gmail.com"]
  spec.summary       = %q{Painless iOS over-the-air enterprise distribution}
  spec.description   = %q{Antenna aims to take the pain out of creating and distributing all the necessary files for Enterprise iOS over-the-air distribution. It generates the mandatory XML manifest, app icons and an HTML file, automatically extracting all the needed information from the specified .ipa file.}
  spec.homepage      = "https://www.github.com/soulchild/antenna"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
  
  spec.add_dependency "aws-sdk", '~> 2.0', '>= 2.0.0'
  spec.add_dependency "commander", "~> 4.3"
  spec.add_dependency "highline", '~> 1.7', '>= 1.7.2'
  spec.add_dependency "CFPropertyList", '~> 2.3', '>= 2.3.0'
  spec.add_dependency "rubyzip", '~> 1.0', '>= 1.0.0'
end
