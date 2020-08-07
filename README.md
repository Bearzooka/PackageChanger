# PackageChanger

Using Ruby-JSS to work with the JSS API, PackageChanger lists the policies in which a package is used and gives the ability to change this package for a new one, and since version 0.3 also has the ability to work with JSS Patch Policies.

## Installation

    $ gem install PackageChanger

## Basic Usage

Once installed, create a configuration file in /etc/packagechanger.conf

You can copy a sample file from the data folder inside the installation path of *PackageChanger* and fill the JSS URL, User and Password.

Once configured, you can use it:

```packagechanger [--silent] [--policy PolicyID] --old OldPackageName --new NewPackageName || --list ListedPackage```

The PolicyID can be either the numeric ID of a JSS policy, or its name between quotes.

Run the first execution with sudo, or change the mode of the file `/private/var/log/packagechanger.log` so all users can write to it.

## Working with Patch Policies

*PackageChanger* works only with titles that are already configured in the _Patch Management_ section of JSS. These titles require:

- A version, provided from the patch source
- A package existing in the JSS
- Policies for _general deployment_ and _testing_

### Configuration

The patch policies are selected by *PackageChanger* using a keyword that must be present in the configuration file:

```
testers_keyword: Testers

release_keyword: General
```
If no patch policy has the defined keyword, *PackageChanger* will fail.

### Usage

A patch management title with an existing version can have a package assigned using:

`PackageChanger --patch [Title] --version [Version number] --new [Full name of the package]`

Once a version has an assigned package, it can be marked for deployment to a test policy by:

`PackageChanger --test [Title] --version [Version number]`

And can be released for general deployment with:

`PackageChanger --release [Title] --version [Version number]`

The release and test flags *will fail* if no patch policies exist for the specified title, using the keywords defined in the config file.


## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/Bearzooka/PackageChanger.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
