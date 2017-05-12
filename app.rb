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
  @bucket = Dribbble::Bucket.find(ENV["token"], '513760')
  @shot_one = @bucket.shots.sample
  @shot_two = @bucket.shots.sample
  @shot_one_tags = @shot_one.tags.sample
  
  #search for second shot based on a tag from the first
#  @shot_two = Dribbble::Shot.search(@shot_one_tag_random).sample
  @answer = @bucket.name
  @shot_one_image = @shot_one.images["normal"]
  @shot_two_image = @shot_two.images["normal"]
  
  #user must guess the shared tag
  haml :relation
end

#get '/search' do
#  #timer based
#  #see if the user can find the image based on 2 keywords
#  @shot = Dribbble::Shot.all(ENV["token"]).sample
#  @shot_image = @shot.images["normal"]
#  #stop and reset button
#end


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

post '/guess-r' do
    @answer = params["tags"]
    @image = params["image"]
    @guess = params["guess"]
    #subset string for the following line
    if @answer.include? @guess
    haml :relation_success
  else
    haml :relation_failed
  end
end
