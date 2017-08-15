
describe "teams" do

  it "spec_name" do
    bas = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com")

    team = Team.new("team")
    team.add_member(bas)

    bas_dobbel = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com")
    team_dobbel = Team.new("team")
    team_dobbel.add_member(bas_dobbel)

    expect(team).to eq team_dobbel
  end

end
