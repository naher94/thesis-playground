require "sinatra"
require 'json'
require 'sinatra/activerecord'
require 'rake'
require 'alexa_skills_ruby'
require 'nokogiri'
require 'open-uri'
require 'haml'
require 'iso8601'

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)

configure :development do
  require 'dotenv'
  Dotenv.load
end

# require any models
# you add to the folder
# using the following syntax:
require_relative './models/search'
require_relative './models/custom_handler'

# enable sessions for this project
enable :sessions

get '/' do
  @last_tag = Search.last.tag
  @photos = get_dribbble_photos(@last_tag)
  haml :index
end

post '/' do
  content_type :json

  handler = CustomHandler.new(application_id: ENV['ALEXA_APPLICATION_ID'], logger: logger)

  begin
    handler.handle(request.body.read)
  rescue AlexaSkillsRuby::InvalidApplicationId => e
    logger.error e.to_s
    403
  end

end

error 401 do
  "Not allowed."
end

private

def get_dribbble_photos(tag)
  url = "https://dribbble.com/search?q=#{ tag.gsub(' ', '+') }"
  document = Nokogiri::HTML(open(url))

  images = document.css(".dribbble-link picture source img")

  return images.to_a
end
