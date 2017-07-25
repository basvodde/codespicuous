
require 'codespicuous'
require 'commithistories_data.rb'

describe "Team commits per week table" do

  before :each do
    @commit_history = COMMIT_HISTORY_WINE_CHEESE
  end

  it "can compare two commit histories" do
    expect(@commit_history).to eq(@commit_history)
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

end

