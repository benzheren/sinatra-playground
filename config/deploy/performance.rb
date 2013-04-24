set :lowio, "61.174.12.197"
set :highio, "61.153.102.81"
role :web, lowio, highio
role :app, lowio, highio
role :db,  lowio, :primary => true

set :deploy_env, "production"
set :rails_env, "production"
set :deploy_to, "/home/deployer/apps/#{application}_#{rails_env}"
set :current_path, "/home/deployer/apps/#{application}_#{rails_env}/current"
set :unicorn_config, "#{current_path}/config/unicorn.rb"
set :unicorn_pid, "#{current_path}/tmp/pids/unicorn.pid"
