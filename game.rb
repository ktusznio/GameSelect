require 'rubygems'
require 'dm-core'
require 'dm-types'
require 'dm-migrations'
require 'dm-validations'

# sqlite3
DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/games.db")

class Game
  include DataMapper::Resource

  property :id,             Serial
  property :name,           String, :required => true
  property :category,       Flag[ :light, :medium, :heavy ]
  property :min_players,    Integer
  property :max_players,    Integer
  property :min_duration,   Integer
  property :max_duration,   Integer
  property :last_played,    DateTime

  validates_uniqueness_of :name

  def self.pick(num_players = nil, duration = nil, 
                category = nil, num_games = 1)
    conds = {}
    conds[:min_players.gte] = num_players unless num_players.blank?
    conds[:max_players.lte] = num_players unless num_players.blank?
    conds[:min_duration.gte] = duration unless duration.blank?
    conds[:max_duration.lte] = duration unless duration.blank?
    conds[:category] = category unless category.blank?

    games = Game.all(conds)
    games.shuffle.first(num_games.to_i)
  end
end

DataMapper.finalize
DataMapper.auto_upgrade!
