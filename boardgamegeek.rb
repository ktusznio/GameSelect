require "net/http"
require "uri"
require "xmlsimple"

module BoardGameGeek

  BGG_URL = "http://www.boardgamegeek.com/xmlapi"

  def self.user_games(user, params = {})
    route = "/collection/#{user}"
    data = self.request(route)
    games = data["item"]
    games = games.map {|game| Game.from_xml(game) }
    games.select do |game|
      game.fits(params)
    end
  end

  def self.random_user_game(user, num_games = 1, params = {})
    games = user_games(user, params)
    games = games.sort_by { rand }
    return games[0] if num_games == 1
    games.slice(0..num_games-1)
  end

  class Game
    attr_accessor :name, :min_players, :max_players, :playtime

    def initialize(hash = {})
      @name        = hash[:name]
      @min_players = hash[:min_players]
      @max_players = hash[:max_players]
      @playtime    = hash[:playtime]
    end

    def players
      min_players..max_players
    end

    def fits(params = {})
      ret = true
      params.each do |name, needed|
        value = send(name)
        if value
          if needed.is_a?(Range)
            if value.is_a?(Range)
              ret &&= (value.first <= needed.last) && (needed.first <= value.last)
            else
              ret &&= needed.include?(value)
            end
          else
            if value.is_a?(Range)
              ret &&= value.include?(needed)
            else
              ret &&= value.eql?(needed)
            end
          end
        end
      end
      ret
    end

    def has_all_attrs
      [:name, :min_players, :max_players, :playtime].detect do |attr|
        send(attr).nil?
      end.nil?
    end

    def self.from_xml(xml)
      Game.new({
        :name        => xml["name"][0]["content"],
        :min_players => xml["stats"][0]["minplayers"].to_i,
        :max_players => xml["stats"][0]["maxplayers"].to_i,
        :playtime    => xml["stats"][0]["playingtime"].to_i
      })
    end

    def self.appears(params = {})
      Game.new({
        :name        => params[:name] || "Random game #{rand(1000)}",
        :min_players => params[:min_players] || 1 + rand(3),
        :max_players => params[:max_players] || 3 + rand(5),
        :playtime    => params[:playtime] || 15 + rand(120)
      })
    end

    def to_s
      name
    end
  end

  private

  def self.request(route)
    url       = URI.parse(BGG_URL + route)
    resp      = Net::HTTP.get_response(url).body
    data_hash = XmlSimple.xml_in(resp)
    data_hash
  end

end
