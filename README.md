capistrano-daemonize adds a daemonize method to Capistrano's DSL to generate tasks that control arbitrary processes as daemons.
It makes use of Debian's /sbin/start-stop-daemon, which is available in every Debian-based Linux distribution like Ubuntu.
OpenSuSE and Mandriva do have the binary in both the sysvinit and dpkg packages.

Sample usage in your `deploy.rb`:

    require 'capistrano-daemonize'
    daemonize '/usr/bin/env bundle exec rake qc:work', as: 'myworker', callbacks: true, role: :worker

This creates three tasks: myworker:start, myworker:stop and myworker:restart.
The namspace is defined by the mandatory option `:as`.

If `:callbacks` is set, the tasks are automatically added to the respective
deploy tasks. You could do that manually by adding:

    after 'deploy:restart', 'myworker:restart'
    after 'deploy:start', 'myworker:start'
    after 'deploy:stop', 'myworker:stop'

You can use the `:pidfile` and `:logfile` options to defined the respective
files, which default to `"#{shared_path}/pids/myworker.pid"` and
`"#{shared_path}/log/myworker.log"`.

`:chdir` may be used to set the working directory for the daemon and
`:user` to switch to another user than logged in.

Other options, like `:role` in the example above, will be used when defining the tasks.
