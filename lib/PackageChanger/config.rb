require 'singleton'
require 'pathname'

module PackageChanger

  silent = false

  class Configuration
    include ::Singleton

    # The location of the default config file
    DEFAULT_CONF_FILE = Pathname.new '/etc/packagechanger.conf'

    SAMPLE_CONF_FILE = Pathname.new(__FILE__).parent.parent.parent + 'data/packagechanger.conf.example'

    CONF_KEYS = {
        jamf_server: nil,
        jamf_port: :to_i,
        jamf_use_ssl: nil,
        jamf_user: nil,
        jamf_password: nil,
        testers_keyword: nil,
        release_keyword: nil
    }.freeze

    # automatically create accessors for all the CONF_KEYS
    CONF_KEYS.keys.each { |k| attr_accessor k }

    # Initialize!
    #
    def initialize
      read_global
    end

    def read_global
      return false unless DEFAULT_CONF_FILE.file? && DEFAULT_CONF_FILE.readable?

      read DEFAULT_CONF_FILE
    end

    def print
      CONF_KEYS.keys.sort.each { |k| puts "#{k}: #{send k}" }
    end

    private

    def read(file)
      available_conf_keys = CONF_KEYS.keys

      # puts file
      Pathname.new(file).read.each_line do |line|
        # skip blank lines and those starting with #
        next if line =~ /^\s*(#|$)/

        line.strip =~ /^(\w+?):\s*(\S.*)$/
        key = Regexp.last_match(1)
        next unless key

        attr = key.to_sym
        next unless available_conf_keys.include? attr

        setter = "#{key}=".to_sym
        value = Regexp.last_match(2).strip

        # convert the string value read from the file
        # to the correct class
        value &&= case CONF_KEYS[attr]
                  when Proc
                    # If its a proc, pass it to the proc
                    CONF_KEYS[attr].call value

                  when Symbol
                    # otherwise its a symbol method name to call on the string
                    value.send(CONF_KEYS[attr])

                  else
                    value

                  end

        send(setter, value)
      end # do line
      true
    end # read file
  end # class Configuration

  # The single instance of Configuration
  def self.config
    PackageChanger::Configuration.instance
  end
end
# module
