

describe "The participants and the teams that we're examining" do

  participants_in_csv = "#,First Name,Last Name,Email,Login,Team,Specialization,Manager,day1,day2,day3,Comments,Present,Questionaire send,Answered,Pretest,Dietary,Commits,Blamed lines,Average LOC/Commit
1,Bas,Vodde,basv@wow.com,basvodde,Wine
2,Janne,Yeah,janne@yeah.com,janne,Cheese
3,Daniel,Hum,daniel@hum.com,daniel,Wine
"
  subject { Participants.new }

  before (:each) do
    parser = ParticipantsParserFromCsv.new.parse(participants_in_csv)
    @participants = parser.participants
    @teams = parser.teams
  end

  it "reads the participants and teams from a CSV" do
    expect(@participants.amount).to eq 3
    expect(@teams.amount).to eq 2
  end

  it "has all the participant information" do
    bas = @participants.find_by_loginname('basvodde')
    expect(bas.first_name).to eq "Bas"
    expect(bas.last_name).to eq "Vodde"
    expect(bas.email).to eq "basv@wow.com"
    expect(bas.team.name).to eq "Wine"
  end

  it "has all the team information" do
    wine = @teams.find_by_name("Wine")
    expect(wine.amount_of_members).to eq 2
    expect(wine.member_loginnames).to include('daniel')
  end
end
