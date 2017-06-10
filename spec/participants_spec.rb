

describe "The committers and the teams that we're examining" do

  committers_in_csv = "#,First Name,Last Name,Email,Login,Team,Specialization,Manager,day1,day2,day3,Comments,Present,Questionaire send,Answered,Pretest,Dietary,Commits,Blamed lines,Average LOC/Commit
1,Bas,Vodde,basv@wow.com,basvodde,Wine
2,Janne,Yeah,janne@yeah.com,janne,Cheese
3,Daniel,Hum,daniel@hum.com,daniel,Wine
"
  subject { committers.new }

  before (:each) do
    parser = CommittersParserFromCsv.new.parse(committers_in_csv)
    @committers = parser.committers
    @teams = parser.teams
  end

  it "reads the committers and teams from a CSV" do
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
end
