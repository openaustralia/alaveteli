# -*- encoding : utf-8 -*-
require 'bundler/capistrano'
require "capistrano-rbenv"

set :stage, 'staging' unless exists? :stage

configuration = YAML.load_file('config/deploy.yml')[stage]

set :application, 'alaveteli'
set :scm, :git
set :deploy_via, :remote_cache
set :repository, configuration['repository']
set :branch, configuration['branch']
set :git_enable_submodules, true
set :deploy_to, configuration['deploy_to']
set :user, configuration['user']
set :use_sudo, false
set :rails_env, configuration['rails_env']
set :daemon_name, configuration.fetch('daemon_name', 'alaveteli')

server configuration['server'], :app, :web, :db, :primary => true

set(:rbenv_ruby_version) do
  command = "cat #{shared_path}/rbenv-version 2>/dev/null || true"
  result = capture(command).strip
  result.empty? ? nil : result
end

if rbenv_ruby_version
  set(:rbenv_path) { capture("echo $HOME/.rbenv").strip }
  set(:rbenv_shims_path) { File.join(rbenv_path, 'shims') }
  set :default_environment, {
    'PATH' => [rbenv_shims_path, '$PATH'].join(':')
  }
end

namespace :themes do
  task :install do
    run "cd #{latest_release} && bundle exec rake themes:install RAILS_ENV=#{rails_env}"
  end
end


# Not in the rake namespace because we're also specifying app-specific arguments here
namespace :xapian do
  desc 'Rebuilds the Xapian index as per the ./scripts/rebuild-xapian-index script'
  task :rebuild_index do
    run "cd #{current_path} && bundle exec rake xapian:rebuild_index models='PublicBody User InfoRequestEvent' RAILS_ENV=#{rails_env}"
  end
end

namespace :rbenv do
  task :setup do
    # Do nothing
  end
end

namespace :deploy do

  [:start, :stop, :restart].each do |t|
    desc "#{t.to_s.capitalize} Alaveteli service defined in /etc/init.d/"
    task t, :roles => :app, :except => { :no_release => true } do
      run "/etc/init.d/#{ daemon_name } #{ t }"
    end
  end

  desc 'Link configuration after a code update'
  task :symlink_configuration do
    links = {
      "#{release_path}/config/database.yml" => "#{shared_path}/database.yml",
      "#{release_path}/config/general.yml" => "#{shared_path}/general.yml",
      "#{release_path}/config/rails_env.rb" => "#{shared_path}/rails_env.rb",
      "#{release_path}/config/newrelic.yml" => "#{shared_path}/newrelic.yml",
      "#{release_path}/config/httpd.conf" => "#{shared_path}/httpd.conf",
      "#{release_path}/config/aliases" => "#{shared_path}/aliases",
      "#{release_path}/public/foi-live-creation.png" => "#{shared_path}/foi-live-creation.png",
      "#{release_path}/public/foi-user-use.png" => "#{shared_path}/foi-user-use.png",
      "#{release_path}/files" => "#{shared_path}/files",
      "#{release_path}/cache" => "#{shared_path}/cache",
      "#{release_path}/log" => "#{shared_path}/log",
      "#{release_path}/tmp/pids" => "#{shared_path}/tmp/pids",
      "#{release_path}/lib/acts_as_xapian/xapiandbs" => "#{shared_path}/xapiandbs",
      "#{release_path}/vendor/data" => "#{shared_path}/vendor_data"
    }

    # TODO: Remove .rbenv-version in favour of .ruby-version
    # For the time being we're using both to allow a smooth transition
    if rbenv_ruby_version
      links["#{release_path}/.rbenv-version"] = "#{shared_path}/rbenv-version"
      links["#{release_path}/.ruby-version"] = "#{shared_path}/rbenv-version"
    end

    # "ln -sf <a> <b>" creates a symbolic link but deletes <b> if it already exists
    run links.map {|a| "ln -sf #{a.last} #{a.first}"}.join(";")
  end

  after 'deploy:setup' do
    run "mkdir -p #{shared_path}/files"
    run "mkdir -p #{shared_path}/cache"
    run "mkdir -p #{shared_path}/log"
    run "mkdir -p #{shared_path}/tmp/pids"
    run "mkdir -p #{shared_path}/xapiandbs"
    run "mkdir -p #{shared_path}/themes"
    run "mkdir -p #{shared_path}/vendor_data"
  end
end

after 'deploy:assets:symlink', 'deploy:symlink_configuration'

before 'deploy:assets:precompile', 'themes:install'

# Put up a maintenance notice if doing a migration which could take a while
before 'deploy:migrate', 'deploy:web:disable'
after 'deploy:migrate', 'deploy:web:enable'

# Clean up old releases so we don't fill up the disk
after "deploy:restart", "deploy:cleanup"
