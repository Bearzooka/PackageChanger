require 'ruby-jss'
require_relative 'config'

module PackageChanger

  def self.connect_to_jss
    # JSS Connection info

    begin
      JSS.api.connect user: PackageChanger.config.jamf_user,
                      pw: PackageChanger.config.jamf_password,
                      server: PackageChanger.config.jamf_server,
                      verify_cert: false

      puts 'Connected to the JSS.'
    rescue
      puts 'Could not connect to JSS. Please check the configuration.'
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

  def self.get_policies_with(list_package, silent)
    result_array = []
    all_policies = JSS::Policy.all.select { |p|
      !(p[:name].include? '[SelfService]') &&
        !(p[:name].include? '1 Computer')
    }
    puts "There are #{all_policies.count} policies in your JSS…" unless silent
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
  end

end # PackageChanger