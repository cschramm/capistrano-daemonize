module Capistrano
  module Daemonize
    class Version
      MAJOR = 0
      MINOR = 9
      PATCH = 0

      def self.to_s
        "#{MAJOR}.#{MINOR}.#{PATCH}"
      end
    end
  end
end