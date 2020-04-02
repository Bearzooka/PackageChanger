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
  end

  def self.get_policies_with(list_package, silent, logger)
    result_array = []
    all_policies = JSS::Policy.all.select { |p|
      !(p[:name].include? '[SelfService]') &&
        !(p[:name].include? '1 Computer')
    }
    puts "\u{203C FE0F}  There are #{all_policies.count} policies in your JSS…"

    confirmation = ''

    while confirmation !~ /[yn]/i
      puts 'Would you like to continue? [y/n]:'
      confirmation = gets.chomp.downcase
    end

    case confirmation
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

end # PackageChanger
