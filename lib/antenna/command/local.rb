require 'distributor'
require 'distributor/local'

command :local do |c|
  c.name = "local"
  c.syntax = "antenna local [options]"
  c.summary = "Distribute .ipa file to local file system"

  c.example 'Distribute "awesome.ipa" to current path', 'antenna local --url https://example.com/ipas/ --file ./awesome.ipa'

  c.option '-f', '--file FILE', '.ipa file to distribute (searches current directory for .ipa files if not specified)'
  c.option '-U', '--url URL', 'Base URL all files should be prefixed with'
  c.option '-i', '--base BASE', "Base filename (optional, defaults to IPA filename without .ipa extension)"

  c.action do |args, options|
    determine_file! unless @file = options.file
    say_error "Missing .ipa file" and abort unless @file and File.exist?(@file)

    local = Antenna::Distributor::Local.new()
    distributor = Antenna::Distributor.new(local)
    puts distributor.distribute @file, {
      :base => options.base,
      :url  => options.url
    }
  end
end
