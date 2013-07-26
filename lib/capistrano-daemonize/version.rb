module Capistrano
  module Daemonize
    class Version
      MAJOR = 0
      MINOR = 9
      PATCH = 1

      def self.to_s
        "#{MAJOR}.#{MINOR}.#{PATCH}"
      end
    end
  end
end
