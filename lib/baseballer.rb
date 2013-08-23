require_relative "baseballer/batter"

module Baseballer
  
  def self.exec
    batters = Batter.load
    print_most_improved_AVG(batters)
    print_OAK_SLG(batters)
    print_most_improved_fantasy_scores("2011", "2012")
    print_triple_crown_winners("2011", "2012")
  end

  def self.print_most_improved_AVG(batters, from_year = "2009", to_year = "2010", limit = 1)
    intro_string = "Most Improved Batting Average#{limit > 1 ? "s" : ""} from #{from_year} to #{to_year}"
    puts intro_string
    puts "=" * intro_string.length
    sorted_avg = batters.sort { |a, b| a.avg_improvement(from_year, to_year) }[0,limit]
    sorted_avg.each {|b| puts b.player_id }
    puts "\n"
  end

  def self.print_OAK_SLG(batters)
    intro_string = "2007 Oakland A's Slugger Percentage"
    puts intro_string
    puts "=" * intro_string.length
    oak_seasons = batters.map do |b| 
      season = b.season_for("2007")
      if season && season["teamID"] == "OAK"
        season
      end
    end.compact
    hits = oak_seasons.inject(0) {|sum, season| sum + season["H"].to_i}
    twoB = oak_seasons.inject(0) {|sum, season| sum + season["2B"].to_i}
    threeB = oak_seasons.inject(0) {|sum, season| sum + season["3B"].to_i}
    hr = oak_seasons.inject(0) {|sum, season| sum + season["HR"].to_i}
    ab = oak_seasons.inject(0) {|sum, season| sum + season["AB"].to_i}
    puts (hits + twoB + (2*threeB) + (3*hr)).to_f/ab
  end

  def self.print_most_improved_fantasy_scores(start_year, end_year, limit = 5)

  end

  def self.print_triple_crown_winners(*args)

  end
end
