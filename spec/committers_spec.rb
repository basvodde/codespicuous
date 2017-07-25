

describe "The committers and the teams that we're examining" do

  subject { committers.new }

  before (:each) do
    @committers = Committers.new
    @teams = Teams.new

    wine = Team.new("Wine")
    cheese = Team.new("Cheese")

    bas = Committer.create_committer("basvodde", "Bas", "Vodde", "basv@wow.com", wine)
    janne = Committer.create_committer("janne", "Janne", "Yeah", "janne@yeah.com", cheese)
    daniel = Committer.create_committer("daniel", "Daniel", "Hum", "daniel@hum.com", wine)

    @committers.add(bas)
    @committers.add(daniel)
    @committers.add(janne)

    wine.add_member(bas)
    wine.add_member(daniel)
    cheese.add_member(janne)

    @teams.add(wine)
    @teams.add(cheese)

  end

  it "can calculate amounts" do
    expect(@committers.amount).to eq 3
    expect(@teams.amount).to eq 2
  end

  it "has all the committer information" do
    bas = @committers.find_by_username('basvodde')
    expect(bas.first_name).to eq "Bas"
    expect(bas.last_name).to eq "Vodde"
    expect(bas.email).to eq "basv@wow.com"
    expect(bas.team.name).to eq "Wine"
  end

  it "has all the team information" do
    wine = @teams.find_by_name("Wine")
    expect(wine.amount_of_members).to eq 2
    expect(wine.member_usernames).to include('daniel')
  end

  it "can compare two committers" do
    team = Team.new("team")
    bas = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com", team)
    dobbel_bas = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com", team)

    expect(bas).to eq dobbel_bas
  end

  it "can compare two committers that aren't equal" do
    team = Team.new("team")
    bas = Committer.create_committer("basv", "Bas", "Fake", "basv@wow.com", team)
    dobbel_bas = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com", team)

    expect(bas).not_to eq dobbel_bas
  end
end

