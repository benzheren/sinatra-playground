rails_env = ENV['RAILS_ENV'] || 'production'

worker_processes (rails_env == 'production' ? 4 : 2)

app_name =  "engzo_stats"

APP_PATH = "/home/deployer/apps/#{app_name}_#{rails_env}/current"

working_directory APP_PATH

listen "/tmp/#{app_name}_#{rails_env}.socket", :backlog => 1024
listen 8080, :tcp_nopush => true

timeout 30

pid APP_PATH + "/tmp/pids/unicorn.pid"

stderr_path APP_PATH + "/log/unicorn.stderr.log"
stdout_path APP_PATH + "/log/unicorn.stdout.log"

preload_app true
GC.respond_to?(:copy_on_write_friendly=) and
  GC.copy_on_write_friendly = true

before_exec do |server|
  ENV["BUNDLE_GEMFILE"] = File.expand_path('../Gemfile', File.dirname(__FILE__))
end

before_fork do |server, worker|
  # the following is highly recomended for Rails + "preload_app true"
  # as there's no need for the master process to hold a connection
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!

  # Before forking, kill the master process that belongs to the .oldbin PID.
  # This enables 0 downtime deploys.
  old_pid = "#{Rails.root}/tmp/pids/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      puts "Send 'QUIT' signal to unicorn error!"
    end
  end
  
end

after_fork do |server, worker|
  # the following is *required* for Rails + "preload_app true"
  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection

end
