# RVM bootstrap
require 'rvm/capistrano'
set :rvm_ruby_string, '1.9.3-p392'
set :rvm_type, :system

# bundler bootstrap
require 'bundler/capistrano'

# multistage deployment
set :stages, %w(production staging performance)
set :default_stage, "staging"
require "capistrano/ext/multistage"

# main details
set :application, "engzo_stats"

# server details
default_run_options[:pty] = true
ssh_options[:forward_agent] = true
set :user, "deployer"
set :group, "staff"
set :use_sudo, false
set :deploy_via, :remote_cache

# repo details
set :scm, :git
set :repository, "git@github.com:benzheren/sinatra-playground.git"
set :branch, "develop"
set :git_enable_submodules, 1

# tasks
task :uname do 
  run "uname -a"
end

task :paths do
  puts "#{current_path}"
  puts "#{shared_path}"
  puts "#{release_path}"
  puts "#{releases_path}"
  puts "#{deploy_to}"
end

set :unicorn_binary, "unicorn"

after "deploy", "deploy:cleanup"

namespace :unicorn do
  desc "start unicorn"
  task :start, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end
  desc "stop unicorn"
  task :stop, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} kill `cat #{unicorn_pid}`"
  end
  desc "unicorn reload"
  task :reload, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end
  desc "graceful stop unicorn"
  task :graceful_stop, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end
  desc "restart unicorn"
  task :restart, :roles => :app, :except => {:no_release => true} do
    stop
    start
  end
end

namespace :deploy do
  task :start, :roles => :app, :except => {:no_release => true} do
    run "cd #{current_path} && bundle exec #{unicorn_binary} -c #{unicorn_config} -E #{rails_env} -D"
  end

  task :stop, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} kill -s QUIT `cat #{unicorn_pid}`"
  end

  desc "Restart Application"
  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} kill -s USR2 `cat #{unicorn_pid}`"
  end  
end

task :mongoid_create_indexes, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=#{rails_env} bundle exec rake db:mongoid:create_indexes"
end

task :mongoid_migrate_database, :roles => :web do
  run "cd #{deploy_to}/current/; RAILS_ENV=#{rails_env} bundle exec rake db:migrate"
end

# hooks
after "deploy:finalize_update","deploy:symlink"
