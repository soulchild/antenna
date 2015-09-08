require 'aws-sdk'
require 'distributor'

module Antenna
  class Distributor::S3
    include Distributor
    
    def initialize(access_key_id, secret_access_key, region = "us-east-1", endpoint = nil)
      options = {
        :access_key_id      => access_key_id,
        :secret_access_key  => secret_access_key,
        :region             => region,
      }
      options[:endpoint] = endpoint if endpoint
      @s3 = Aws::S3::Resource.new(options)
    end

    def distribute_ipa(ipa, options = {})
      options[:acl] ||= "private"

      if options[:create]
        puts "Creating bucket #{options[:bucket]} with ACL #{options[:acl]}..."

        @s3.create_bucket({
          :bucket => options[:bucket],
          :acl => options[:acl],        
        })
      end

      puts "Distributing ipa \"#{ipa.filename}\" to bucket \"#{@options[:bucket]}\"..."

      url = File.open(ipa.filename) do |file|
        object = @s3.bucket(@options[:bucket]).put_object({
          :key          => File.basename(ipa.filename),
          :body         => file,
          :content_type => "application/octet-stream",
          :acl          => options[:acl]
        })
        object.presigned_url(:get, { :expires_in => @expiration })
      end

      URI.parse(url)
    end

    def distribute_app_icon(app_icon, options = {})
      if app_icon
        puts "Distributing app icon..."
      end
    end

    def distribute_manifest(manifest, options = {})
      puts "Distributing manifest..."

      object = @s3.bucket(@options[:bucket]).put_object({
        :key          => "manifest.plist",
        :body         => manifest.to_s,
        :content_type => "text/xml",
      })

      URI.parse(object.presigned_url(:get, { :expires_in => @expiration }))
    end

    def distribute_html(html, options = {})
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