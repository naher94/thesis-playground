require "sinatra"
require 'json'
require 'rake'
require 'nokogiri'
require 'open-uri'
require 'haml'
require 'iso8601'
require "base64"
require 'dribbble'

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)

configure :development do
  require 'dotenv'
  Dotenv.load
end

get '/' do
  @shot = Dribbble::Shot.all(ENV["token"]).sample
  @shot_image = @shot.images["normal"]
  @shot_tags = Base64.encode64(Base64.encode64(@shot.tags.to_json))
  haml :index
end

post '/guess' do
  @tags = JSON.parse(Base64.decode64(Base64.decode64(params["tags"])))
  @image = params["image"]
  @guess = params["guess"]

  if @tags.include? @guess
    haml :success
  else
    haml :failed
  end
end
