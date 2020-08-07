# frozen_string_literal: true
module PackageChanger
  class Log
    DEFAULT_FILE = Pathname.new '/var/log/packagechanger.log'

    # date and line format
    DATE_FORMAT = '%Y-%m-%d %H:%M:%S'

    def initialize
      File.write(DEFAULT_FILE, "≈≈≈ PackageChanger ≈≈≈\n", mode: 'a') unless (DEFAULT_FILE.file? && DEFAULT_FILE.writable?)
    end

    def write(message)
      File.write(DEFAULT_FILE, "#{Time.now.strftime(DATE_FORMAT)} - #{message}\n", mode: 'a')
    end

    def putsandlog(message)
      puts message
      write message
    end
  end
  # Class Log
end
# MOdule
