require "rubygems"
require 'bundler/setup'
Bundler.require(:default)
Bundler.require(:development) if development?
Bundler.require(:test) if test?

Mongoid.load!("mongoid.yml")

require File.expand_path '../engzo_stats.rb', __FILE__

run EngzoStats
