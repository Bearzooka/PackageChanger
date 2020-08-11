require 'ruby-jss'
require_relative 'config'

module PackageChanger

  def self.connect_to_jss(silent)
    # JSS Connection info

    begin
      JSS.api.connect user: PackageChanger.config.jamf_user,
                      pw: PackageChanger.config.jamf_password,
                      server: PackageChanger.config.jamf_server,
                      verify_cert: false

      puts "\u{1F50C} Connected to the JSS." unless silent
    rescue
      puts "\u{1F6AB} Could not connect to JSS. Please check the configuration."
      # abort
    end
  end

  def self.replace_packages(policies, old_package, new_package, silent, logger)
    puts 'Starting replacement process' unless silent

    policies.each do |policy|
      puts "Changing #{policy[:name]}" unless silent
      logger.write("Changing #{policy[:name]}")
      begin
        changed_pol = JSS::Policy.fetch :id => policy[:id]
        changed_pol.remove_package(old_package)
        changed_pol.add_package(new_package)
        changed_pol.update
      rescue StandardError => e
        puts "Changed failed due to error: #{e.message}"
        logger.write("Changed on #{policy} failed due to error: #{e.message}")
      end
    end
  end

  def self.replace_packages_in(changed_pol, old_package, new_package, silent, logger)
    puts 'Starting replacement process' unless silent
    puts 'Processing changes.' unless silent
    logger.write('Starting changes.')

    puts "Changing #{changed_pol.name}" unless silent
    logger.write("Changing #{changed_pol.name}")
    begin
      changed_pol.remove_package(old_package)
      changed_pol.add_package(new_package)
      changed_pol.update
    rescue StandardError => e
      puts "\u{1F6AB} Changed failed due to error: #{e.message}"
      logger.write("Changed on #{changed_pol.name} failed due to error: #{e.message}")
    end
    puts "\u{1F3C1} Finished changing packages." unless silent
    logger.write('Finished changing.')

  end

  def self.get_policies_with(list_package, silent, logger)
    result_array = []
    all_policies = JSS::Policy.all.select { |p|
      !(p[:name].include? '[SelfService]') &&
        !(p[:name].include? '1 Computer')
    }
    puts "\u{203C FE0F}  There are #{all_policies.count} policies in your JSS…"

    case confirm
    when 'y'
      pol_count = 1
      all_policies.each do |policy|
        puts "\r#{pol_count} policies checked" unless silent
        one_result = {}
        fetched_policy = JSS::Policy.fetch(:id => policy[:id])
        if fetched_policy.packages.any? {|package| package[:name] == list_package}
          one_result[:id] = fetched_policy.id
          one_result[:name] = fetched_policy.name
          result_array.push(one_result)
        end
        #end
        pol_count += 1
      end
      return result_array

    when 'n'
      puts 'Cancelling checks.'
      logger.write('User cancelled.')
      exit 0
    else
      puts PackageChanger::ERROR
      logger.write(PackageChanger::ERROR)
      exit 1
    end
  end

  def self.check_patch(app_title, new_package, version, silent, logger)
    unless (patch_id = JSS::PatchTitle.valid_id(app_title))
      logger.write("No patch management for #{app_title} exists")
      puts PackageChanger::MISSING_PATCH_MGMT
      exit 1
    end
    puts "\u{1f4bb} #{app_title} has a patch policy with ID #{patch_id}." unless silent
    logger.write("Preparing change to #{app_title} with ID #{patch_id}.")

    unless JSS::Package.valid_id(new_package)
      logger.write("#{new_package} does not exist")
      puts PackageChanger::MISSING_ONE_PACKAGE
      exit 1
    end
    puts "\u{1F4E6} #{new_package} is available in JSS." unless silent
    logger.write("#{new_package} is available in JSS.")

    patch_title = JSS::PatchTitle.fetch id: patch_id
    unless patch_title.versions[version]
      logger.write("#{app_title} does not have version #{version}")
      puts PackageChanger::MISSING_VERSION
      exit 1
    end
    puts "\u{1f516} #{app_title} has a version #{version}" unless silent
    logger.write("#{app_title} has a version #{version}")

    patch_title
  end
  # check_patch

  def self.assign_patch(patch_title, new_package, version, silent, logger)
    puts "\u{1F3A2} Updating patch policy." unless silent
    logger.write("Setting #{new_package} for version #{version} of #{patch_title}")
    patch_title.versions[version].package = new_package
    patch_title.update
    puts "\u{1F3C1} Finished changing patch policy." unless silent
    logger.write("Patch definition of #{patch_title} updated")
  end
  # assign_patch

  def self.check_version_for_mode(app_title, version, mode, silent, logger)
    unless (patch_id = JSS::PatchTitle.valid_id(app_title))
      logger.write("No patch management for #{app_title} exists")
      puts PackageChanger::MISSING_PATCH_MGMT
      exit 1
    end
    puts "\u{1f4bb} #{app_title} has a patch definition with ID #{patch_id}." unless silent
    logger.write("Preparing change to enable #{mode} of #{app_title} with patch ID #{patch_id}.")

    patch_title = JSS::PatchTitle.fetch id: patch_id
    patch_version = patch_title.versions[version]
    unless patch_version&.package_assigned?
      logger.write("#{app_title} does not have version #{version}")
      puts PackageChanger::MISSING_VERSION
      exit 1
    end
    puts "\u{1f516} #{app_title} has a version #{version} and it has an assigned package" unless silent
    logger.write("#{app_title} has a version #{version} and it has an assigned package")

    policies = (JSS::PatchPolicy.all_for_title app_title) # Gets all with the title
    case mode
    when 'test'
      keyword = PackageChanger.config.testers_keyword
    when 'release'
      keyword = PackageChanger.config.release_keyword
    else
      logger.write("Wrong mode introduced")
      exit 1
    end

    begin
      policies.find { |pol| pol[:name].include? keyword }[:id]
    rescue StandardError => _e
      puts PackageChanger::MISSING_POLICY
      exit 1
    end
  end
  # check_version_for_mode

  def self.activate_patch_for_mode(app_title, mode, version, policy_id, silent, logger)
    puts "\u{1F3A2} Updating #{mode} patch for #{app_title}." unless silent
    logger.write("Assigning version #{version} to #{mode} group.")
    policy = JSS::PatchPolicy.fetch policy_id
    policy.disable
    puts "\u{23F8} Patch policy temporary disabled." unless silent
    policy.target_version = version
    puts "\u{1F517} Version #{version} assigned." unless silent
    policy.enable
    puts "\u{25B6} Patch policy reenabled." unless silent
    policy.update
    puts "\u{1F3C1} Values updated." unless silent
    logger.write("Patch of #{app_title} updated for testers")
  end
  # activate_patch_for_mode

end
# PackageChanger
