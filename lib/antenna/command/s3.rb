require 'distributor'
require 'distributor/s3'

command :s3 do |c|
  c.name = "s3"
  c.syntax = "antenna s3 [options]"
  c.summary = "Distribute .ipa file over Amazon S3"

  c.example 'Distribute "awesome.ipa" to S3 bucket "bucket_name"', 'antenna s3 --file ./awesome.ipa -a access_key_id -s secret_access_key --create -b bucket_name'

  c.option '-f', '--file FILE', '.ipa file to distribute (searches current directory for .ipa files if not specified)'
  c.option '-a', '--access-key-id ACCESS_KEY_ID', 'S3 access key ID'
  c.option '-s', '--secret-access-key SECRET_ACCESS_KEY', 'S3 secret access key'
  c.option '-b', '--bucket BUCKET', 'S3 bucket name'
  c.option '--[no-]create', "(Don't) create bucket if it doesn't already exist"
  c.option '-r', '--region REGION', "AWS region (optional, defaults to us-east-1)"
  c.option '-e', '--endpoint ENDPOINT', "S3 endpoint (optional, e.g. https://mys3.example.com)"
  c.option '-x', '--expires EXPIRES', "Expiration of URLs in seconds (optional, e.g. 86400 = one day)"
  c.option '-i', '--base BASE', "Base filename (optional, defaults to IPA filename without .ipa extension)"
  c.option '--acl ACL', "Permissions for uploaded files. Must be one of: public_read, private, public_read_write, authenticated_read (optional, defaults to private)"

  c.action do |args, options|
    determine_file! unless @file = options.file
    say_error "Missing .ipa file" and abort unless @file and File.exist?(@file)

    determine_access_key_id! unless @access_key_id = options.access_key_id
    say_error "Missing S3 access key ID" and abort unless @access_key_id

    determine_secret_access_key! unless @secret_access_key = options.secret_access_key
    say_error "Missing S3 secret access key" and abort unless @secret_access_key

    determine_bucket! unless @bucket = options.bucket
    say_error "Missing S3 bucket name" and abort unless @bucket

    @endpoint = options.endpoint
    unless @endpoint
      determine_region! unless @region = options.region
      say_error "Missing either S3 region or endpoint" and abort unless @region
    end

    s3 = Antenna::Distributor::S3.new(@access_key_id, @secret_access_key, @region, @endpoint)
    distributor = Antenna::Distributor.new(s3)
    puts distributor.distribute @file, { :bucket => @bucket, :create => !!options.create, :expire => options.expires, :acl => @acl, :base => options.base } 
  end

  private

  def determine_access_key_id!
    @access_key_id ||= ENV['AWS_ACCESS_KEY_ID']
    @access_key_id ||= ask "S3 access key ID:"
  end

  def determine_secret_access_key!
    @secret_access_key ||= ENV['AWS_SECRET_ACCESS_KEY']
    @secret_access_key ||= ask "S3 secret access key:"
  end

  def determine_bucket!
    @bucket ||= ENV['AWS_BUCKET']
    @bucket ||= ask "S3 bucket name:"
  end

  def determine_region!
    @region ||= ENV['AWS_REGION']
  end
end