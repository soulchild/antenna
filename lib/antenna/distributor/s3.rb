require 'aws-sdk'
require 'distributor'

module Antenna
  class Distributor::S3
    include Distributor
    
    def initialize(access_key_id, secret_access_key, region, endpoint = nil)
      options = {
        :access_key_id      => access_key_id,
        :secret_access_key  => secret_access_key,
        :region             => region || "us-east-1",
      }
      options[:endpoint] = endpoint if endpoint
      @s3 = Aws::S3::Resource.new(options)
    end

    def setup(ipa_file, options = {})
      @options = options
      @options[:expire]   ||= 86400
      @options[:acl]      ||= "private"
      @options[:base_key] ||= File.basename(ipa_file, ".ipa")
    end

    def distribute_ipa(ipa)
      if @options[:create]
        puts "Creating bucket #{@options[:bucket]} with ACL #{@options[:acl]}..."

        @s3.create_bucket({
          :bucket => @options[:bucket],
          :acl    => @options[:acl],        
        })
      end

      puts "Distributing ipa \"#{ipa.filename}\"..."

      url = File.open(ipa.filename) do |file|
        object = @s3.bucket(@options[:bucket]).put_object({
          :key          => "#{@options[:base_key]}.ipa",
          :body         => file,
          :content_type => "application/octet-stream",
          :acl          => @options[:acl]
        })
        object.presigned_url(:get, { :expires_in => @options[:expire] })
      end

      URI.parse(url)
    end

    def distribute_app_icon(app_icon)
      if app_icon
        puts "Distributing app icon..."

        object = @s3.bucket(@options[:bucket]).put_object({
          :key          => "#{@options[:base_key]}.png",
          :body         => app_icon,
          :content_type => "image/png",
        })

        URI.parse(object.presigned_url(:get, { :expires_in => @options[:expire] }))
      end
    end

    def distribute_manifest(manifest)
      puts "Distributing manifest..."

      object = @s3.bucket(@options[:bucket]).put_object({
        :key          => "#{@options[:base_key]}.plist",
        :body         => manifest.to_s,
        :content_type => "text/xml",
      })

      URI.parse(object.presigned_url(:get, { :expires_in => @options[:expire] }))
    end

    def distribute_html(html)
      puts "Distributing HTML..."

      object = @s3.bucket(@options[:bucket]).put_object({
        :key          => "#{@options[:base_key]}.html",
        :body         => html.to_s,
        :content_type => "text/html",
      })

      URI.parse(object.presigned_url(:get, { :expires_in => @options[:expire] }))
    end
  end
end