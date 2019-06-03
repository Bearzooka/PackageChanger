# PackageChanger

Using Ruby-JSS to work with the JSS API, PackageChange lists the policies in which a package is used and gives the ability to change this package for a new one.

## Installation

    $ gem install PackageChanger

## Usage

Once installed, create a configuration file in /etc/packagechanger.conf

You can copy a sample file from the data folder inside the installation path of *PackageChanger* and fill the JSS URL, User and Password.

Once configured, you can use it:

```packagechanger [--silent] --old OldPackageName --new NewPackageName || --list ListedPackage```


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Bearzooka/PackageChanger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
