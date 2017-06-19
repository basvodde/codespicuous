
require 'codespicuous'

describe "Team commits per week table" do

  commits_in_daniel_format = "
repository: osaka
*** basvodde
team:                  Wine
commits in week:
  2016-04-17: 2 commits
  2016-05-01: 2 commits

*** daniel
team:                  Cheese
commits in week:
  2016-03-27: 1 commits

*** basvodde
team:                  Wine
commits in week:
  2016-03-13: 4 commits
  2016-04-03: 1 commits

repository: cpputest

*** janne
team: Wine
commits in week:
  2016-02-28: 1 commits
  2016-04-03: 3 commits
  2016-05-15: 3 commits"

  before :each do
    @commit_history = DanielFormatParser.new.parse(commits_in_daniel_format)
    @stats = CommitStatistics.new
    @stats.teams = @commit_history.teams
    @stats.commits = @commit_history.commits
  end

  it "calculates the amount of committers" do
    expect(@commit_history.amount_of_comitters).to eq(3)
  end

  it "knows the team the person is in" do
    expect(@commit_history.committer("basvodde").team.name).to eq "Wine"
  end

  it "can extract the commit amounts per user per week" do
    expect(@commit_history.committer("basvodde").amount_of_weeks_committed_to_repository("osaka")).to eq 4
  end

  it "can extract the commits per user" do
    expect(@commit_history.committer("basvodde").amount_of_commits_to_repository_in_week("osaka", DateTime.new(2016,03,13))).to eq 4
    expect(@commit_history.committer("basvodde").amount_of_commits_to_repository_in_week("osaka", DateTime.new(2016,04,17))).to eq 2
  end

  it "should be able to extract all the repositories" do
    expect(@commit_history.repository_names).to include "osaka"
  end

  it "should be able to extract all the teams" do
    expect(@commit_history.teams.team_names).to eq ["Wine", "Cheese"]
  end

  it "Should be able to create the wonderful table (sorted on team)" do
    table = "Committer,Team,osaka,cpputest,Total
basvodde,Wine,9,0,9
janne,Wine,0,7,7
daniel,Cheese,1,0,1
"
    expect(@commit_history.create_commit_table_with_committers_and_repository_info).to eq table
  end

  it "should be able to find the earliest commit date" do
    expect(@commit_history.earliest_commit_date).to eq DateTime.new(2016,02,28)
  end

  it "should be able to find the latest commit date" do
    expect(@stats.last_week_committed).to eq DateTime.new(2016,05,15)
  end

  it "Should be able to get the amount of commits per team per week without commits" do
    expect(@stats.amount_of_commits_for_team_in_week("Cheese", "2016-01-01")).to eq 0
  end

  it "Should be able to get the amount of commits per team per week" do
    expect(@stats.amount_of_commits_for_team_in_week("Cheese", DateTime.new(2016,03,27))).to eq 1
  end

  it "Should make a time table with commits and team" do
    table = "Week,Cheese,Wine
2016-02-28,0,1
2016-03-06,0,0
2016-03-13,0,4
2016-03-20,0,0
2016-03-27,1,0
2016-04-03,0,4
2016-04-10,0,0
2016-04-17,0,2
2016-04-24,0,0
2016-05-01,0,2
2016-05-08,0,0
2016-05-15,0,3
"
    expect(@stats.create_commit_table_with_weeks_and_team_commits).to eq table
  end

  it "Should make a time table with commits per repository" do
    table = "Week,osaka,cpputest
2016-02-28,0,1
2016-03-06,0,0
2016-03-13,4,0
2016-03-20,0,0
2016-03-27,1,0
2016-04-03,1,3
2016-04-10,0,0
2016-04-17,2,0
2016-04-24,0,0
2016-05-01,2,0
2016-05-08,0,0
2016-05-15,0,3
"
    expect(@stats.create_commit_table_with_week_and_repository_info).to eq table
  end

  it "Should make a time table with commits per user" do
    table = "Week,basvodde,janne,daniel
2016-02-28,0,1,0
2016-03-06,0,0,0
2016-03-13,4,0,0
2016-03-20,0,0,0
2016-03-27,0,0,1
2016-04-03,1,3,0
2016-04-10,0,0,0
2016-04-17,2,0,0
2016-04-24,0,0,0
2016-05-01,2,0,0
2016-05-08,0,0,0
2016-05-15,0,3,0
"
    expect(@stats.create_commit_table_with_weeks_and_committers).to eq table
  end

  it "Should make a time table with commits per user in team" do
    table = "Week,basvodde,janne
2016-02-28,0,1
2016-03-06,0,0
2016-03-13,4,0
2016-03-20,0,0
2016-03-27,0,0
2016-04-03,1,3
2016-04-10,0,0
2016-04-17,2,0
2016-04-24,0,0
2016-05-01,2,0
2016-05-08,0,0
2016-05-15,0,3
"
    expect(@stats.create_commit_table_with_weeks_and_committers("Wine")).to eq table
  end
end

