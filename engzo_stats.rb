class UserEvent
  include Mongoid::Document

  field :timestamp, type: Float
  field :type, type: Integer
  field :data, type: Hash
end

class EngzoStats < Sinatra::Base
  configure :development do
    use BetterErrors::Middleware
    # you need to set the application root in order to abbreviate filenames
    # within the application:
    BetterErrors.application_root = File.expand_path('..', __FILE__)

    register Sinatra::Reloader

    enable :logging
  end

  get '/' do
    'hello, world'
  end
  
  post '/userevents' do
    data = JSON.parse(request.body.read)
    logger.info data
    ue = UserEvent.new(data["event"])
    if ue.save
      status 201
      return {}.to_json
    else
      return 404
    end
  end

end
