require_relative "baseballer/batter"

module Baseballer
  
  def self.exec
    batters = Batter.load
    print_most_improved_AVG(batters)
    print_OAK_SLG
    print_most_improved_fantasy_scores("2011", "2012")
    print_triple_crown_winners("2011", "2012")
  end

  def self.print_most_improved_AVG(batters, from_year = "2009", to_year = "2010", limit = 1)
    intro_string = "Most Improved Batting Average#{limit > 1 ? "s" : ""}"
    puts intro_string
    puts "=" * intro_string.length
    sorted_avg = batters.sort { |a, b| a.avg_improvement(from_year, to_year) }[0,limit]
    sorted_avg.each {|b| puts b.player_id }
  end

  def self.print_OAK_SLG(batters)
    intro_string = "Most Improved Batting Average#{limit > 1 ? "s" : ""}"
    puts intro_string
    puts "=" * intro_string.length
    sorted_avg = batters.sort { |a, b| a.avg_improvement(from_year, to_year) }[0,limit]
    sorted_avg.each {|b| puts b.player_id }

  end

  def self.print_most_improved_fantasy_scores(start_year, end_year, limit = 5)

  end

  def self.print_triple_crown_winners(*args)

  end
end
