# frozen_string_literal: true

module PackageChanger
  USAGE = "

≈≈≈ PackageChanger ≈≈≈

  Usage: packagechanger --old OldPackageName --new NewPackageName
"


  CONFIG_ERROR = "

≈≈≈ PackageChanger ≈≈≈

  [ERROR] The configuration file is missing in /etc/packagechanger.conf

  You can copy a sample file from the data folder inside the installation path of PackageChanger and
  fill the JSS URL, User and Password.

"

  MISSSING_PACKAGE = "

≈≈≈ PackageChanger ≈≈≈

  Missing packages: One or both of the provided packages do not exist. Please verify.
"

  MISSSING_LIST_PACKAGE = "

≈≈≈ PackageChanger ≈≈≈

  Missing package: The provided package does not exist. Please verify.
"

  NO_RESULTS_LIST = "

  There are no policies using the provided package.
"

  NO_RESULTS_CHANGE = "

  There are no policies using the package you intend to change.
"

 ERROR = "

  Execution error.
"
end
