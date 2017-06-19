
require 'codespicuous'

describe "Team commits per week table" do

  commits_in_daniel_format = "
repository: osaka
*** basvodde
team:                  Wine
commits in week:
  2016-04-18: 2 commits
  2016-05-02: 2 commits

*** daniel
team:                  Cheese
commits in week:
  2016-03-28: 1 commits

*** basvodde
team:                  Wine
commits in week:
  2016-03-14: 4 commits
  2016-04-04: 1 commits

repository: cpputest

*** janne
team: Wine
commits in week:
  2016-02-29: 1 commits
  2016-04-04: 3 commits
  2016-05-16: 3 commits"

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
    expect(@commit_history.committer("basvodde").amount_of_commits_to_repository_in_week("osaka", DateTime.new(2016,03,14))).to eq 4
    expect(@commit_history.committer("basvodde").amount_of_commits_to_repository_in_week("osaka", DateTime.new(2016,04,18))).to eq 2
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
    expect(@commit_history.earliest_commit_date).to eq DateTime.new(2016,02,29)
  end

  it "should be able to find the latest commit date" do
    expect(@commit_history.latest_commit_date).to eq DateTime.new(2016,05,16)
  end

  it "Should be able to get the amount of commits per team per week without commits" do
    expect(@commit_history.amount_of_commits_for_team_in_week("Cheese", DateTime.new(2016,01,01))).to eq 0
  end

  it "Should be able to get the amount of commits per team per week" do
    expect(@commit_history.amount_of_commits_for_team_in_week("Cheese", DateTime.new(2016,03,28))).to eq 1
  end

  it "Should make a time table with commits and team" do
    table = "Week,Wine,Cheese
2016-02-29,1,0
2016-03-07,0,0
2016-03-14,4,0
2016-03-21,0,0
2016-03-28,0,1
2016-04-04,4,0
2016-04-11,0,0
2016-04-18,2,0
2016-04-25,0,0
2016-05-02,2,0
2016-05-09,0,0
2016-05-16,3,0
"
    expect(@commit_history.create_commit_table_with_weeks_and_team_commits).to eq table
  end

  it "Should make a time table with commits per repository" do
    table = "Week,osaka,cpputest
2016-02-29,0,1
2016-03-07,0,0
2016-03-14,4,0
2016-03-21,0,0
2016-03-28,1,0
2016-04-04,1,3
2016-04-11,0,0
2016-04-18,2,0
2016-04-25,0,0
2016-05-02,2,0
2016-05-09,0,0
2016-05-16,0,3
"
    expect(@stats.create_commit_table_with_week_and_repository_info).to eq table
  end

  it "Should make a time table with commits per user" do
    table = "Week,basvodde,janne,daniel
2016-02-29,0,1,0
2016-03-07,0,0,0
2016-03-14,4,0,0
2016-03-21,0,0,0
2016-03-28,0,0,1
2016-04-04,1,3,0
2016-04-11,0,0,0
2016-04-18,2,0,0
2016-04-25,0,0,0
2016-05-02,2,0,0
2016-05-09,0,0,0
2016-05-16,0,3,0
"
    expect(@stats.create_commit_table_with_weeks_and_committers).to eq table
  end

  it "Should make a time table with commits per user in team" do
    table = "Week,basvodde,janne
2016-02-29,0,1
2016-03-07,0,0
2016-03-14,4,0
2016-03-21,0,0
2016-03-28,0,0
2016-04-04,1,3
2016-04-11,0,0
2016-04-18,2,0
2016-04-25,0,0
2016-05-02,2,0
2016-05-09,0,0
2016-05-16,0,3
"
    expect(@stats.create_commit_table_with_weeks_and_committers("Wine")).to eq table
  end
end

