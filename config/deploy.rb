require 'bundler/capistrano'

set :stage, 'staging' unless exists? :stage

configuration = YAML.load_file('config/deploy.yml')[stage]

# Load general_config from local file if it exists, otherwise use defaults
# The actual configuration will be loaded from the remote server during deployment
if File.exist?('config/general.yml')
  general_config = YAML.load_file('config/general.yml')
else
  general_config = {}
end

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

server configuration['server'], :app, :web, :db, primary: true

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
  desc 'Rebuilds the Xapian index as per the ./scripts/destroy-and-rebuild-xapian-index script'
  task :destroy_and_rebuild_index do
    run "cd #{current_path} && bundle exec rake xapian:destroy_and_rebuild_index models='PublicBody User InfoRequestEvent' RAILS_ENV=#{rails_env}"
  end
end

# Disable the default asset pipeline
set :normalize_asset_timestamps, false

namespace :deploy do

  namespace :assets do
    desc 'Clean up old manifest files before precompilation'
    task :clean_manifests do
      run "rm -f #{shared_path}/assets/manifest*"
      run "rm -f #{shared_path}/assets/.sprockets-manifest*"
    end

    # Override the default asset pipeline check to avoid manifest file conflicts
    task :update_asset_mtimes do
      # Skip the problematic manifest file check
    end

    desc 'Precompile assets manually'
    task :precompile do
      run "cd #{latest_release} && RAILS_ENV=#{rails_env} RAILS_GROUPS=assets bundle exec rake assets:precompile"
    end

    desc 'Symlink non-digest asset paths to the most recent digest versions'
    task :link_non_digest do
      run "cd #{latest_release} && bundle exec rake assets:link_non_digest RAILS_ENV=#{rails_env}"
    end
  end

  [:start, :stop, :restart].each do |t|
    desc "#{t.to_s.capitalize} Alaveteli service defined in /etc/init.d/"
    task t, roles: :app, except: { no_release: true } do
      run "/etc/init.d/#{ daemon_name } #{ t }"
    end
  end

  desc 'Link configuration after a code update'
  task :symlink_configuration do
    # Load general.yml from the remote shared directory
    general_yml_content = capture("cat #{shared_path}/general.yml")
    remote_general_config = YAML.load(general_yml_content)

    links = {}

    # Add shared files from general.yml
    shared_files = remote_general_config['SHARED_FILES'] || []
    shared_files.each do |file|
      links["#{release_path}/#{file}"] = "#{shared_path}/#{File.basename(file)}"
    end

    # Add shared directories from general.yml
    shared_directories = remote_general_config['SHARED_DIRECTORIES'] || []
    shared_directories.each do |dir|
      dir_name = dir.chomp('/')
      # Map lib/acts_as_xapian/xapiandbs/ to xapiandbs for backward compatibility
      if dir_name == 'lib/acts_as_xapian/xapiandbs'
        links["#{release_path}/#{dir_name}"] = "#{shared_path}/xapiandbs"
      else
        links["#{release_path}/#{dir_name}"] = "#{shared_path}/#{File.basename(dir_name)}"
      end
    end

    # Add themes directory (not in general.yml but always needed)
    links["#{release_path}/lib/themes"] = "#{shared_path}/themes"

    if rbenv_ruby_version
      links["#{release_path}/.rbenv-version"] = "#{shared_path}/rbenv-version"
    end

    # "ln -sf <a> <b>" creates a symbolic link but deletes <b> if it already exists
    run links.map { |a| "ln -sf #{a.last} #{a.first}" }.join(";")
  end

  after 'deploy:setup' do
    # Check if general.yml exists in shared directory
    general_yml_exists = capture("test -f #{shared_path}/general.yml && echo 'exists' || echo 'missing'").strip

    if general_yml_exists == 'exists'
      # Load general.yml from the remote shared directory
      general_yml_content = capture("cat #{shared_path}/general.yml")
      remote_general_config = YAML.load(general_yml_content)

      # Create directories for shared directories from general.yml
      shared_directories = remote_general_config['SHARED_DIRECTORIES'] || []
      shared_directories.each do |dir|
        dir_name = dir.chomp('/')
        # Map lib/acts_as_xapian/xapiandbs/ to xapiandbs for backward compatibility
        if dir_name == 'lib/acts_as_xapian/xapiandbs'
          run "mkdir -p #{shared_path}/xapiandbs"
        else
          run "mkdir -p #{shared_path}/#{File.basename(dir_name)}"
        end
      end
    else
      # Fallback to defaults if general.yml doesn't exist yet
      puts "WARNING: #{shared_path}/general.yml not found. Using default shared directories."
      run "mkdir -p #{shared_path}/files"
      run "mkdir -p #{shared_path}/storage"
      run "mkdir -p #{shared_path}/cache"
      run "mkdir -p #{shared_path}/log"
      run "mkdir -p #{shared_path}/tmp/pids"
      run "mkdir -p #{shared_path}/xapiandbs"
      run "mkdir -p #{shared_path}/vendor/bundle"
      run "mkdir -p #{shared_path}/assets"
    end

    # Always create themes directory (not in general.yml but always needed)
    run "mkdir -p #{shared_path}/themes"
  end
end

after 'deploy:assets:symlink', 'deploy:symlink_configuration'

before 'deploy:assets:precompile', 'deploy:assets:clean_manifests'
before 'deploy:assets:precompile', 'themes:install'
after 'deploy:assets:precompile', 'deploy:assets:link_non_digest'

# Put up a maintenance notice if doing a migration which could take a while
before 'deploy:migrate', 'deploy:web:disable'
after 'deploy:migrate', 'deploy:web:enable'
