set :domain, "61.174.15.166"
role :web, domain 
role :app, domain
role :db,  domain, :primary => true

set :deploy_env, "staging"
set :rails_env, "staging"
set :deploy_to, "/home/deployer/apps/#{application}_#{rails_env}"
set :current_path, "/home/deployer/apps/#{application}_#{rails_env}/current"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
