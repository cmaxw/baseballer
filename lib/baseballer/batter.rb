require 'csv'

module Baseballer
  class Batter
    attr_accessor :player_id, :seasons

    def self.load(file_path = "../../data/Batting-07-12.csv")
      path_to_file = File.expand_path(file_path, File.dirname(__FILE__))
      @batters = []
      batters_by_id = {}
      CSV.foreach(path_to_file, headers: true, return_headers: false) do |row|
        player_id = row["playerID"]
        batter = if batters_by_id[player_id]
                   batters_by_id[player_id]
                 else
                   new_batter = Batter.new(player_id)
                   batters_by_id[player_id] = new_batter
                   @batters << new_batter
                   new_batter
                 end
        batter.seasons << row
      end
      @batters
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
      return 0 if season["AB"].to_i == 0 || season["AB"].to_i < 200
      season["H"].to_f/season["AB"].to_f
    end

    def rbi_for(year)
      season = season_for(year)
      season["RBI"].to_i
    end

    def hr_for(year)
      season = season_for(year)
      season["HR"].to_i
    end

    def avg_improvement(from_year, to_year)
      from_season = season_for(from_year)
      to_season = season_for(to_year)
      return -1 if from_season.nil? || to_season.nil? || from_season["AB"].to_i < 200 || to_season["AB"].to_i < 200
      avg_for(to_year) - avg_for(from_year)
    end

    def fantasy_score_for(year)
      season = season_for(year)
      (season["HR"].to_i * 4) + season["RBI"].to_i + season["SB"].to_i - season["CS"].to_i
    end

    def fantasy_improvement(from_year, to_year)
      from_season = season_for(from_year)
      to_season = season_for(to_year)
      return -1 if from_season.nil? || to_season.nil? || from_season["AB"].to_i < 500 || to_season["AB"].to_i < 500
      fantasy_score_for(to_year) - fantasy_score_for(from_year)
    end

    def self.triple_crown_for(year)
      batters = self.from_season(year).select {|b| b.season_for(year)["AB"].to_i > 550}
      
      avg_winners = batters.sort { |a, b| b.avg_for(year) <=> a.avg_for(year)}
      avg_winners.select! {|b| b.avg_for(year) == avg_winners.first.avg_for(year) }
      rbi_winners = batters.sort { |a, b| b.rbi_for(year) <=> a.rbi_for(year)}
      rbi_winners.select! {|b| b.rbi_for(year) == rbi_winners.first.rbi_for(year) }
      hr_winners = batters.sort { |a, b| b.hr_for(year) <=> a.hr_for(year)}
      hr_winners.select! {|b| b.hr_for(year) == rbi_winners.first.hr_for(year) }

      (avg_winners & rbi_winners & hr_winners).first
    end

    def self.from_season(year)
      @batters.select {|b| b.season_for(year)}
    end

    def self.from_season_and_team(year, team)
      from_season(year).select { |b| b.season_for(year)["teamID"] == team }
    end
  end
end
