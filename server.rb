require 'rubygems'
require 'sinatra'
require 'game'

puts 'Starting server...'

get '/' do
  @games = Game.all(:order => [:name.asc])
  erb :index
end

post '/pick' do
  @games = Game.all
  @picked_games = Game.pick(params[:num_players], params[:duration],
    params[:category], params[:num_games])
  erb :index
end

get '/game/:id' do
  @game = Game.get(params[:id])
  erb :game
end

post '/game/:id' do
  @game = Game.get(params[:id])

  keys = [:name, :category, :min_players, :max_players,
    :min_duration, :max_duration, :last_played]

  keys.each do |k|
    @game[k] = params[k] unless params[k].blank?
  end

  @game.save
  redirect '/'
end

