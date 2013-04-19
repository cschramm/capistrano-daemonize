# -*- encoding: utf-8 -*-
require File.expand_path('../lib/capistrano-daemonize/version', __FILE__)

Gem::Specification.new do |s|
  s.name        = 'capistrano-daemonize'
  s.version     = Capistrano::Daemonize::Version.to_s
  s.platform    = Gem::Platform::RUBY
  s.author      = 'Christopher Schramm'
  s.email       = 'cschramm@shakaweb.org'
  s.homepage    = 'https://github.com/cschramm/capistrano-daemonize'
  s.summary     = %q{Control arbitrary jobs using start-stop-daemon in Capistrano}
  s.description = %q{Adds a daemonize method to the Capistrano DSL to generate start, stop and restart tasks for an arbitrary command controlled with start-stop-daemon.}
  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = %w(lib)
  s.extra_rdoc_files = %w(README.md)

  s.add_development_dependency 'rake'

  s.add_runtime_dependency 'capistrano'
end