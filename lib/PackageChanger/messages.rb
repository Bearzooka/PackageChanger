# frozen_string_literal: true

module PackageChanger
  USAGE = "

≈≈≈ PackageChanger ≈≈≈

  Usage: packagechanger [--silent] [--policy PolicyID] --old OldPackageName --new NewPackageName || --list ListedPackage
"

PATCH_USAGE = "

≈≈≈ PackageChanger ≈≈≈

  Patch definition usage: packagechanger [--silent] --patch PatchDefinitionID --version PatchVersion --new NewPackageName
"


  CONFIG_ERROR = "

≈≈≈ PackageChanger ≈≈≈

  [ERROR] The configuration file is missing in /etc/packagechanger.conf

  You can copy a sample file from the data folder inside the installation path of PackageChanger and
  fill the JSS URL, User and Password.

"

  MISSING_PACKAGE = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing packages: One or both of the provided packages do not exist. Please verify.
"

  MISSING_PATCH_MGMT = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing patch definition: The provided software title does not have a patch definition. Please verify.
"

  MISSING_ONE_PACKAGE = "

≈≈≈ PackageChanger ≈≈≈

\u{1f4a9} Missing package: The package provided does not exist in JAMF. Please verify.
"

  MISSING_VERSION = "

≈≈≈ PackageChanger ≈≈≈

\u{1f4a9} Missing version: The patch definition for the title does not have the provided version registered.
"

  MISSING_POLICY = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing policy: The policy ID you provided does not exist. Please verify.
"

  MISSING_LIST_PACKAGE = "

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

  MISSING_TESTERS = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing testers group: In order to start testing the patch, a patch policy with the word Testers in its name needs to exist for the title.
"

  MISSING_PATCH_POLICY = "

≈≈≈ PackageChanger ≈≈≈

  \u{1f4a9} Missing patch policy: The title you are trying to change does not have a patch policy with one of the keywords (test or release) in the title.
"

  def self.confirm
    confirmation = ''
    while confirmation !~ /[yn]/i
      puts 'Please confirm [y/n]:'
      confirmation = gets.chomp.downcase
    end
    confirmation
  end

end
