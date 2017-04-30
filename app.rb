require "sinatra"
require 'json'
require 'rake'
require 'nokogiri'
require 'open-uri'
require 'haml'
require 'iso8601'
require 'dribbble'

# Load environment variables using Dotenv. If a .env file exists, it will
# set environment variables from that file (useful for dev environments)

configure :development do
  require 'dotenv'
  Dotenv.load
end

get '/' do
  @shot = Dribbble::Shot.all(ENV["token"]).sample
  haml :index
end

private

def get_dribbble_photos(tag)
  url = "https://dribbble.com/search?q=#{ tag }"
  document = Nokogiri::HTML(open(url))

  images = document.css(".dribbble-link picture source img")
  user_tags = document.css(".")

  return images.to_a
end
