require 'aws-sdk'
require 'transport'

module Antenna
  class Transport::S3
    include Transport
    
    def initialize(access_key_id, secret_access_key, options = {})
      @options = options
      @options[:expire] ||= 86400
      @expiration = 3600

      init_options = {
        :access_key_id      => access_key_id,
        :secret_access_key  => secret_access_key,
        :region             => @options[:region] || "us-west-2",
      }
      init_options[:endpoint] = @options[:endpoint] if @options[:endpoint]

      @s3 = Aws::S3::Resource.new(init_options)
    end

    def distribute_ipa(ipa)
      if @options[:create]
        puts "Creating bucket #{@options[:bucket]} with ACL #{@options[:acl]}..."

        @s3.create_bucket({
          :bucket => @options[:bucket],
          :acl => @options[:acl] || "private",        
        })
      end

      puts "Distributing ipa \"#{ipa.filename}\" to bucket \"#{@options[:bucket]}\"..."

      url = File.open(ipa.filename) do |file|
        object = @s3.bucket(@options[:bucket]).put_object({
          :key          => File.basename(ipa.filename),
          :body         => file,
          :content_type => "application/octet-stream"
        })
        object.presigned_url(:get, { :expires_in => @expiration })
      end

      URI.parse(url)
    end

    def distribute_app_icon(app_icon)
      if app_icon
        puts "Distributing app icon..."
      end
    end

    def distribute_manifest(manifest)
      puts "Distributing manifest..."

      object = @s3.bucket(@options[:bucket]).put_object({
        :key          => "manifest.plist",
        :body         => manifest.to_s,
        :content_type => "text/xml",
      })

      URI.parse(object.presigned_url(:get, { :expires_in => @expiration }))
    end

    def distribute_html(html)
      puts "Distributing HTML..."

      object = @s3.bucket(@options[:bucket]).put_object({
        :key          => "html.html",
        :body         => html.to_s,
        :content_type => "text/html",
      })

      URI.parse(object.presigned_url(:get, { :expires_in => @expiration }))
    end
  end
end