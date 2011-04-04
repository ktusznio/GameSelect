require "rubygems"
require "sinatra"

puts "Starting server..."

get "/" do
  haml :index
end
