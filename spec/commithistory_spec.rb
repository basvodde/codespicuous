
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

  context "extracting a subset of the commit history" do

    before (:each) do
      @large_commit_history = CommitHistoryBuilder.new.
        in_repository("one").
          commits_of("basvodde").of_team("Wine").
            at("2016-04-18").times(2).
          commits_of("daniel").of_team("Cheese").
            at("2016-03-28").
          commits_of("janne").without_team.
            at("2016-08-18").times(2).
        in_repository("cpputest").
          commits_of("janne").without_team.
            at("2016-02-29").
        build

      @restricted_commit_history = @large_commit_history.restrict_to_teams
    end

    it "will only have two committers in the restricted commit history" do
      expect(@large_commit_history.amount_of_comitters).to eq 3
      expect(@restricted_commit_history.amount_of_comitters).to eq 2
    end

    it "will only have the repositories of the restricted committers" do
      expect(@large_commit_history.amount_of_repositories).to eq 2
      expect(@restricted_commit_history.amount_of_repositories).to eq 1
    end

    it "will also be able to get the right amount of commits via the reposities" do
      expect(@large_commit_history.repository("one").amount_of_commits).to eq 5
      expect(@restricted_commit_history.repository("one").amount_of_commits).to eq 3
    end

    it "will also be able to get the right amount of commits via the comitter" do
      expect(@large_commit_history.committer("basvodde").amount_of_commits).to eq 2
      expect(@restricted_commit_history.committer("basvodde").amount_of_commits).to eq 2
    end

    it "will also be able to get the right amount of team members in the teams" do
      expect(@large_commit_history.team("Wine").amount_of_members).to eq 1
      expect(@restricted_commit_history.team("Wine").amount_of_members).to eq 1
    end
  end
end

