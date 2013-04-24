set :domain, "61.174.9.227"
role :web, domain#, "61.174.15.185", "61.174.15.150"
role :app, domain#, "61.174.15.185", "61.174.15.150"
role :db,  domain, :primary => true

set :deploy_env, "production"
set :rails_env, "production"
set :deploy_to, "/home/deployer/apps/#{application}_#{rails_env}"
set :current_path, "/home/deployer/apps/#{application}_#{rails_env}/current"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
