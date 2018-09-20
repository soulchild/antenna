require 'uri'

module Antenna
  class Distributor::Local
    def initialize()
    end

    def setup(ipa_file, options = {})
      @options = options
    end

    def distribute(data, filename, content_type)
      puts "Distributing #{filename} ..."

      target = open(filename, 'w')
      target.write(data)
      target.close

      if @options[:url]
        URI.join(@options[:url], filename)
      else
        filename
      end
    end
  end
end
