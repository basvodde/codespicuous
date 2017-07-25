
describe "teams" do

  it "spec_name" do
    team = Team.new("team")
    bas = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com", team)
    team.add_member(bas)

    team_dobbel = Team.new("team")
    bas_dobbel = Committer.create_committer("basv", "Bas", "Vodde", "basv@wow.com", team)
    team_dobbel.add_member(bas_dobbel)

    expect(team).to eq team_dobbel
  end

end
