# Antenna

Antenna aims to take the pain out of creating and distributing all the necessary files for Enterprise iOS over-the-air distribution. It generates the mandatory XML manifest, app icons and an HTML file, automatically extracting all the needed information from the specified `.ipa` file. The result is a (signed S3) URL, which you may then send to your clients, so they can easily install your app from Mobile Safari. Currently only S3 is supported, but it is easy and encouraged to create other storage backends.

## Installation

```bash
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

Create a new S3 bucket called `antenna-ota` on Amazon's `eu-central-1` S3 cluster and upload OverTheAir.ipa:

```bash
$ antenna s3 -a <YOUR-S3-ACCESS-KEY> -s <YOUR-S3-SECRET-KEY> --file OverTheAir.ipa --region eu-central-1 --create --bucket antenna-ota
Distributing OverTheAir.ipa ...
Distributing OverTheAir.png ...
Distributing OverTheAir.plist ...
Distributing OverTheAir.html ...
https://antenna-ota.s3.eu-central-1.amazonaws.com/OverTheAir.html?<...signing-parameters...>
```

The resulting URL leads to an installation page like the following and can be distributed to your users for installation. The meta-data and app-icon is automatically extracted from the given .ipa file.

![Installation site](https://raw.githubusercontent.com/soulchild/antenna/master/assets/example-installation.png)

*Note:* App icons in any .ipa file are converted from PNG to [Apple's CgBI file format](http://iphonedevwiki.net/index.php/CgBI_file_format) and therefore not viewable in most applications, including Chrome and Firefox. Apple applications like (Mobile) Safari or Preview.app know how to handle the format though.

## Author

Tobi Kremer ([soulchild](https://www.github.com/soulchild))

## Contributing

Bug reports and pull requests are welcome on [GitHub](https://github.com/soulchild/antenna).

## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).