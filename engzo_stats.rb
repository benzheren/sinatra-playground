require "rubygems"
require "sinatra/base"

class EngzoStats < Sinatra::Base

  get '/' do
    'Hello, nginx and unicorn!'
  end

end
