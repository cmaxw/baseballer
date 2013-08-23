require 'spec_helper'

module Baseballer
  describe Batter do
    before :each do
      @row = CSV::Row.new(%w(playerID yearID teamID G AB R H 2B 3B HR RBI SB CS), 
                         %w(britches01 2012 SEA 154 573 88 146 41 1 20 78 24 10))
      @row2 = CSV::Row.new(%w(playerID yearID teamID G AB R H 2B 3B HR RBI SB CS), 
                         %w(britches01 2013 SEA 154 573 88 246 41 1 20 78 24 10))
    end

    it "loads batters from the CSV" do
      file_path = "../data/Batting-07-12.csv"
      path_to_file = File.expand_path(file_path, File.dirname(__FILE__))

      batters = Baseballer::Batter.load

      player_ids = []
      CSV.foreach(path_to_file, headers: true, return_headers: false) do |row|
        player_ids << row["playerID"]
      end

      batters.length.should == player_ids.uniq.length
      batters.each do |batter|
        batter.should be_a(Batter)
      end
    end

    it "creates batters from a CSV row" do
      batter = Baseballer::Batter.new(@row["playerID"])
      batter.player_id.should == "britches01"
      batter.seasons.should be_empty
    end

    it "calculates the batting average for a season" do 
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row
      batter.avg_for("2012").should == (146.to_f/573.to_f)
    end

    it "calculates the batting average improvement from one season to the another" do
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row
      batter.seasons << @row2
      batter.avg_improvement("2012", "2013").should == (246.to_f/573) - (146.to_f/573)
    end

    it "returns a -1 AVG improvement if any season has below 200 hits" do
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row
      @row2["AB"] = "199"
      batter.seasons << @row2
      batter.avg_improvement("2012", "2013").should == -1
    end

    it "returns a -1 AVG improvement if the batter didn't play one of the seasons" do
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row2
      batter.avg_improvement("2012", "2013").should == -1
    end

    it "calculates the fantasy score for a given batter" do
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row
      batter.fantasy_score_for("2012").should == 80 + 78 + 24 - 10
    end

    it "calculates the improvement in fantasy score for a given batter" do
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row
      batter.seasons << @row2
      batter.fantasy_improvement("2012", "2013").should == 0
    end

    it "returns a -1 AVG improvement if any season has below 200 hits" do
      batter = Batter.new(@row["playerID"])
      batter.seasons << @row
      @row2["AB"] = "499"
      batter.seasons << @row2
      batter.fantasy_improvement("2012", "2013").should == -1
    end

  end
end
