require "rubygems"
require "json"
require "sinatra"

require "boardgamegeek"

puts "Starting server..."

get "/" do
  haml :index
end

post "/random" do
  username = params[:username]
  limit    = params[:num_games].to_i || 5
  players  = params[:num_players].to_i
  playtime = params[:playtime].to_i

  options = {}
  options[:players] = players if players > 0
  options[:playtime] = playtime if playtime > 0

  games = BoardGameGeek.random_user_game(username, limit, options)

  content_type :json
  games.to_json
end
