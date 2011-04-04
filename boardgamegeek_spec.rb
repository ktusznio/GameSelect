require "bgg"

describe BoardGameGeek, "#user_games" do
  before do
    @test_user = "mbingo"
  end

  it "returns a user's games" do
    games = BoardGameGeek.user_games(@test_user)
    games.should_not be_empty
  end

  it "parses a game's data (name, min users, max users, playtime)" do
    games = BoardGameGeek.user_games(@test_user)
    game = games.first
    game.has_all_attrs.should == true
  end

end

describe BoardGameGeek, "#random_user_game" do
  before do
    @game = BoardGameGeek::Game.appears
  end

  it "returns a random game" do
    BoardGameGeek.stub!(:from_xml).and_return(@game)
    game = BoardGameGeek.random_user_game("mbingo")
    game.should.eql? @game
    game.has_all_attrs.should == true
  end

  it "returns multiple random games" do
    BoardGameGeek.stub!(:from_xml).and_return(@game)
    BoardGameGeek.random_user_game("mbingo", 5).size.should == 5
  end
end

describe BoardGameGeek::Game, "fits" do
  before do
    @game = BoardGameGeek::Game.appears({
      :min_players => 2,
      :max_players => 5,
      :playtime    => 90
    })
  end

  it "takes a number of players" do
    @game.fits(:players => 1).should == false
    @game.fits(:players => 2).should == true
    @game.fits(:players => 3).should == true
    @game.fits(:players => 5).should == true
    @game.fits(:players => 10).should == false
  end

  it "takes a playtime range" do
    @game.fits(:playtime => 30..60).should == false
    @game.fits(:playtime => 60..120).should == true
    @game.fits(:playtime => 90..120).should == true
    @game.fits(:playtime => 60..90).should == true
    @game.fits(:playtime => 100..120).should == false
  end
end
