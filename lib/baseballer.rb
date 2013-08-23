require_relative "baseballer/batter"

module Baseballer
  
  def self.exec
    batters = Batter.load
    print_most_improved_AVG(batters)
    print_OAK_SLG(batters)
    print_most_improved_fantasy_scores(batters, "2011", "2012")
    print_triple_crown_winners(batters, "2011", "2012")
  end

  def self.print_most_improved_AVG(batters, from_year = "2009", to_year = "2010", limit = 1)
    print_title "Most Improved Batting Average#{limit > 1 ? "s" : ""} from #{from_year} to #{to_year}"

    sorted_avg = batters.sort { |a, b| b.avg_improvement(from_year, to_year) <=> a.avg_improvement(from_year, to_year)}[0,limit]
    sorted_avg.each {|b| puts b.player_id }
  end

  def self.print_OAK_SLG(batters)
    print_title "2007 Oakland A's Slugger Percentage"

    batters = Batter.from_season_and_team("2007", "OAK")
    oak_seasons = batters.map {|b| b.season_for("2007")}

    hits = oak_seasons.inject(0) {|sum, season| sum + season["H"].to_i}
    twoB = oak_seasons.inject(0) {|sum, season| sum + season["2B"].to_i}
    threeB = oak_seasons.inject(0) {|sum, season| sum + season["3B"].to_i}
    hr = oak_seasons.inject(0) {|sum, season| sum + season["HR"].to_i}
    ab = oak_seasons.inject(0) {|sum, season| sum + season["AB"].to_i}
    puts (hits + twoB + (2*threeB) + (3*hr)).to_f/ab
  end

  def self.print_most_improved_fantasy_scores(batters, from_year, to_year, limit = 5)
    print_title "Most Improved Fantasy Scores for 2011-2012"

    fantasy_batters = batters.sort do |a, b| 
      b.fantasy_improvement(from_year, to_year) <=> a.fantasy_improvement(from_year, to_year)
    end
    fantasy_batters[0, limit].each {|b| puts b.player_id}
  end

  def self.print_triple_crown_winners(*args)
    batters = args.shift
    args.each do |year|
      print_title "Triple Crown Winner for #{year}"
      tc_winner = Batter.triple_crown_for(year)
      puts tc_winner ? tc_winner.player_id : "(No winner)"
    end
  end

  def self.print_title(title)
    puts "\n"
    puts title
    puts "=" * title.length
  end
end
