[![Build Status](https://travis-ci.org/soulchild/antenna.svg?branch=master)](https://travis-ci.org/soulchild/antenna)

# Antenna

Antenna aims to take the pain out of creating and distributing all the necessary files for Enterprise iOS over-the-air distribution. It generates the mandatory XML manifest, app icons and an HTML file, automatically extracting all the needed information from the specified `.ipa` file, and uploads everything via a distribution method of your choice (currently only S3 is supported, but you're encouraged to create other storage backends). The result is a (signed S3) URL, which you may then send to your clients, so they can easily install your app from Mobile Safari with just one tap.

## Installation

```bash
gem install antenna-ota
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

## Examples

### 1. Private, signed URL

Create a new S3 bucket called `antenna-ota` on Amazon's `eu-central-1` S3 cluster and upload OverTheAir.ipa, resulting in a signed URL for distribution:

```bash
$ antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file OverTheAir.ipa --region eu-central-1 --create --bucket antenna-ota
Distributing OverTheAir.ipa ...
Distributing OverTheAir.png ...
Distributing OverTheAir.plist ...
Distributing OverTheAir.html ...
https://antenna-ota.s3.eu-central-1.amazonaws.com/OverTheAir.html?<...signing-parameters...>
```

### 2. Public, unsigned URL

Upload OverTheAir.ipa to Amazon's `eu-central-1` S3 cluster, resulting in a publically available, unsigned URL for distribution:

```bash
$ antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file OverTheAir.ipa --public --acl public-read --region eu-central-1 --bucket antenna-ota
Distributing OverTheAir.ipa ...
Distributing OverTheAir.png ...
Distributing OverTheAir.plist ...
Distributing OverTheAir.html ...
https://antenna-ota.s3.eu-central-1.amazonaws.com/OverTheAir.html
```

The resulting URLs show an installation page like the following and can be distributed to your users for installation. The meta-data and app-icon is automatically extracted from the given .ipa file:

![Installation site](https://raw.githubusercontent.com/soulchild/antenna/master/assets/example-installation.png)

*Note:* App icons in any .ipa file are converted from PNG to [Apple's CgBI file format](http://iphonedevwiki.net/index.php/CgBI_file_format) and therefore not viewable in most applications, including Chrome and Firefox. Apple applications like (Mobile) Safari or Preview.app know how to handle the format though.

## Author

Tobi Kremer ([soulchild](https://www.github.com/soulchild))

Inspired by Mattt Thompson's [iOS toolchain](https://github.com/nomad).

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/soulchild/antenna).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).