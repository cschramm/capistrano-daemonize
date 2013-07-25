module Capistrano
  class Configuration
    def daemonize(command, options)
      raise "Must pass a hash containing 'as'" if not options.is_a?(Hash) or
                                                  not options.has_key?(:as)

      name = options.delete(:as)
      opts = Hash[[:pidfile, :logfile, :chdir, :user].map do
          |option| [option, options.delete(option)]
      end]
      callbacks = options.delete(:callbacks)
      sudo_command = ''

      before(%w(start stop restart).map { |action| "#{name}:#{action}" }) do
        _cset(:rails_env) { fetch(:rails_env) || 'production' }
        _cset(:daemonize_pidfile) do
          opts[:pidfile] || "#{fetch(:shared_path)}/pids/#{name}.pid"
        end
        _cset(:daemonize_logfile) do
          opts[:logfile] || "#{fetch(:shared_path)}/log/#{name}.log"
        end
        _cset(:daemonize_chdir) { opts[:chdir] || fetch(:current_path) }
        _cset(:daemonize_user) { opts[:user] || fetch(:user) }
        _cset(:daemonize_sudo) do
          opts[:user] == fetch(:user) && try_sudo || ''
        end
      end

      namespace name do
        task :start, { desc: "Start #{name}" }.merge(options) do
          run <<-SCRIPT
if [ -e #{daemonize_pidfile} ]; then
  echo 'pidfile exists';
  exit 1;
fi;

#{daemonize_sudo} /sbin/start-stop-daemon --pidfile #{daemonize_pidfile} \
--start --make-pidfile --chdir #{daemonize_chdir} --user #{daemonize_user} \
--background --exec #{command.split[0]} -- #{command.split[1..-1].join(' ')} \
2>&1 >>#{daemonize_logfile} RAILS_ENV=#{rails_env};
sleep 1
          SCRIPT
        end

        task :stop, { desc: "Stop #{name}" }.merge(options) do
          run <<-SCRIPT
#{sudo_command} /sbin/start-stop-daemon --stop --pidfile #{daemonize_pidfile};
rm -f #{daemonize_pidfile}
          SCRIPT
        end

        task :restart, { desc: "Restart #{name}" }.merge(options) do
          stop
          start
        end
      end

      if callbacks
        after 'deploy:start', "#{name}:start"
        after 'deploy:stop', "#{name}:stop"
        after 'deploy:restart', "#{name}:restart"
      end
    end
  end
end
