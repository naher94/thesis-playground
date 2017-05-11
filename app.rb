require "sinatra"
require 'json'
require 'rake'
require 'nokogiri'
require 'open-uri'
require 'haml'
require 'iso8601'
require "base64"
require 'dribbble'


enable :sessions

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)

configure :development do
  require 'dotenv'
  Dotenv.load
end

get '/' do
  haml :index
end

get '/sandbox' do
  #@lives = session["lives"]
  #@lives = 3
  
  # Pulling a shot at random from the homepage
  @shot = Dribbble::Shot.all(ENV["token"]).sample
  @shot_image = @shot.images["normal"]
  
  # Pulling the tags from the shot
  @shot_tags = Base64.encode64(Base64.encode64(@shot.tags.to_json))
  haml :sandbox
end

get '/relation' do
  #Pull 2 shots with the same tag
  @shot_one = Dribbble::Shot.all(ENV["token"]).sample
  @shot_one_tag_random = @shot_one.tags.sample
  
  #search for second shot based on a tag from the first
  @shot_two = Dribbble::Shot.search(@shot_one_tag_random).sample
  
  @shot_one_image = @shot_one.images["normal"]
  @shot_two_image = @shot_two.images["normal"]
  
  #user must guess the shared tag
  haml :relation
end


post '/guess' do
  #@lives = session["lives"]
  @tags = JSON.parse(Base64.decode64(Base64.decode64(params["tags"])))
  @image = params["image"]
  @guess = params["guess"]

  if @tags.include? @guess
    haml :sandbox_success
  else
    #@lives = @lives - 1
    haml :sandbox_failed
  end
end
