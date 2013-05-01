require "bundler/capistrano"
require "rvm/capistrano"
require 'airbrake/capistrano'
load 'deploy/assets'

load "config/recipes/base"

set :rvm_ruby_string, ENV['GEM_HOME'].gsub(/.*\//,"")
set :rvm_type, :user
set :rvm_install_ruby, :install
set :application, "MindvalleyDaily"
set :server_name, 'daily.mindvalley.net'
set :repository,  "git@github.com:mindvalley/daily_v2.git"
set :user, "mvdev"
set :deploy_to, "/home/#{user}/apps/#{application}"
set :use_sudo, false
set :git_enable_submodules, 1

set :deploy_via, :remote_cache

# so there is no need to add specific server keys
ssh_options[:forward_agent] = true
namespace :ssh do
  task :start_agent do
    `ssh-add`
  end
end
before 'deploy:update_code', 'ssh:start_agent'
before 'deploy:setup', 'rvm:install_rvm'
before 'deploy:setup', 'rvm:install_ruby'
# after "deploy:update", "foreman:export"    # Export foreman scripts
# after "deploy:update", "foreman:restart"   # Restart application scripts

default_run_options[:pty] = true

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :stages, %w(production staging)
set :default_stage, "staging"
require 'capistrano/ext/multistage'

namespace :deploy do
  task :restart do
    run "/etc/init.d/rainbows_#{application} restart"
  end

  task :stop do
    run "/etc/init.d/rainbows_#{application} stop"
  end
end

namespace :foreman do
  desc 'Export the Procfile to Ubuntu upstart scripts'
  task :export, :roles => :app do

    run "cd #{release_path} && bundle exec foreman export upstart /etc/init -a #{application} -u #{user} -l #{release_path}/log/foreman"

  end

  desc "Start the application services"
  task :start, :roles => :app do

    sudo "start #{application}"
  end

  desc "Stop the application services"

  task :stop, :roles => :app do
    sudo "stop #{application}"

  end

  desc "Restart the application services"
  task :restart, :roles => :app do

    run "sudo start #{application} || sudo restart #{application}"
  end
end

namespace :rails do
  desc "Open the rails console on one of the remote servers"
  task :console, :roles => :app do
    host = find_servers_for_task(current_task).first
    exec "ssh -p #{port || 22} -l #{user || 'root'} #{host} -t 'rvm_path=/home/#{user}/.rvm/ /home/#{user}/.rvm/bin/rvm-shell \"#{rvm_ruby_string}\" -c \"cd #{current_release} && bundle exec rails console #{stage}\"'"
  end
end

set :max_asset_age, 2 ## Set asset age in minutes to test modified date against.
 
after "deploy:finalize_update", "deploy:assets:determine_modified_assets", "deploy:assets:conditionally_precompile"
 
namespace :deploy do
  namespace :assets do
    
    desc "Figure out modified assets."
    task :determine_modified_assets, :roles => assets_role, :except => { :no_release => true } do
      set :updated_assets, capture("find #{latest_release}/app/assets -type d -name .git -prune -o -mmin -#{max_asset_age} -type f -print", :except => { :no_release => true }).split
    end
    
    desc "Remove callback for asset precompiling unless assets were updated in most recent git commit."
    task :conditionally_precompile, :roles => assets_role, :except => { :no_release => true } do
      if(updated_assets.empty?)
        callback = callbacks[:after].find{|c| c.source == "deploy:assets:precompile" }
        callbacks[:after].delete(callback)
        logger.info("Skipping asset precompiling, no updated assets.")
      else
        logger.info("#{updated_assets.length} updated assets. Will precompile.")
      end
    end
    
  end
end