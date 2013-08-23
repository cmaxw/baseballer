require 'csv'

module Baseballer
  class Batter
    attr_accessor :player_id, :seasons

    def self.load(file_path = "../../data/Batting-07-12.csv")
      path_to_file = File.expand_path(file_path, File.dirname(__FILE__))
      batters = []
      batters_by_id = {}
      CSV.foreach(path_to_file, headers: true, return_headers: false) do |row|
        player_id = row["playerID"]
        batter = if batters_by_id[player_id]
                   batters_by_id[player_id]
                 else
                   new_batter = Batter.new(player_id)
                   batters_by_id[player_id] = new_batter
                   batters << new_batter
                   new_batter
                 end
        batter.seasons << row
      end
      batters
    end

    def initialize(player_id)
      @player_id = player_id
      @seasons = []
    end

    def season_for(year)
      seasons.select {|s| s["yearID"] == year}.first
    end

    def avg_for(year)
      season = season_for(year)
      season["H"].to_f/season["AB"].to_f
    end
    
    def avg_improvement(from_year, to_year)
      from_season = season_for(from_year)
      to_season = season_for(to_year)
      return -1 if from_season.nil? || to_season.nil? || from_season["AB"].to_i < 200 || to_season["AB"].to_i < 200
      avg_for(to_year) - avg_for(from_year)
    end

    def slg_for(year)
      season = season_for(year)
      (season["H"].to_i + season["2B"].to_i + (season["3B"].to_i * 2) + (season["HR"].to_i * 3)).to_f/season["AB"].to_i
    end
  end
end
