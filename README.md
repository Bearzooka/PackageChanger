# PackageChanger

Using Ruby-JSS to work with the JSS API, PackageChange lists the policies in which a package is used and gives the ability to change this package for a new one.

## Installation

    $ gem install PackageChanger

## Usage

Once installed, create a configuration file in /etc/packagechanger.conf

You can copy a sample file from the data folder inside the installation path of *PackageChanger* and fill the JSS URL, User and Password.

Once configured, you can use it:

```packagechanger [--silent] [-- policy PolicyID] --old OldPackageName --new NewPackageName || --list ListedPackage```

The PolicyID can be either the numeric ID of a JSS policy, or its name between quotes.

Run the first execution with sudo, or change the mode of the file `/private/var/log/packagechanger.log` so all users can write to it.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Bearzooka/PackageChanger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
