# Antenna

Antenna aims to take the pain out of creating and distributing all the necessary files for Enterprise iOS over-the-air distribution. It generates the mandatory XML manifest, app icons and an HTML file, automatically extracting all the needed information from the specified `.ipa` file. The result is a (signed S3) URL, which you may then send to your clients, so they can install your app **with just one tap** from Mobile Safari. Currently only S3 is supported, but it is easy and encouraged to create other storage backends.

## Installation

```ruby
gem install antenna
```

## Usage

Antenna adds the `antenna` command to your PATH:

```bash
$ antenna

  Antenna

  Painless iOS over-the-air enterprise distribution

  Commands:
    help    Display global or [command] help documentation
    s3      Distribute .ipa file over Amazon S3

  Global Options:
    --verbose
    -h, --help           Display help documentation
    -v, --version        Display version information
    -t, --trace          Display backtrace when an error occurs
```

## Example

```bash
antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file <YOUR-IPA-FILE> --region us-east-1 --create --bucket ios-apps
```

You may also use a custom endpoint if you're hosting your own S3 cluster (something like [Ceph's Object Gateway S3](http://ceph.com/docs/master/radosgw/s3/)):

```bash
antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file <YOUR-IPA-FILE> --endpoint https://s3.mydomain.com --create --bucket ios-apps
```

The resulting URL leads to the following installation site:

![Installation site](https://raw.githubusercontent.com/soulchild/antenna/master/assets/example-installation.png)

## Author

Tobi Kremer ([soulchild](https://www.github.com/soulchild))

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/soulchild/antenna).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).