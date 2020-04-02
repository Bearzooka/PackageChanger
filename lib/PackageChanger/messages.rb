# frozen_string_literal: true

module PackageChanger
  USAGE = "

≈≈≈ PackageChanger ≈≈≈

  Usage: packagechanger [--silent] [--policy PolicyID] --old OldPackageName --new NewPackageName || --list ListedPackage
"


  CONFIG_ERROR = "

≈≈≈ PackageChanger ≈≈≈

  [ERROR] The configuration file is missing in /etc/packagechanger.conf

  You can copy a sample file from the data folder inside the installation path of PackageChanger and
  fill the JSS URL, User and Password.

"

  MISSSING_PACKAGE = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing packages: One or both of the provided packages do not exist. Please verify.
"

  MISSSING_POLICY = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing policy: The policy ID you provided does not exist. Please verify.
"

  MISSSING_LIST_PACKAGE = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing package: The provided package does not exist. Please verify.
"

  NO_RESULTS_LIST = "

  \u{1F6AB 1F4E6} There are no policies using the provided package.
"

  NO_RESULTS_CHANGE = "

  \u{1F6AB 1F4E6} There are no policies using the package you intend to change.
"

 ERROR = "

  Execution error.
"

STARTUP = "
≈≈≈ PackageChanger ≈≈≈
"
end
