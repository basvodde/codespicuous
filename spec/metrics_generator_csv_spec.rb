
require 'commithistories_data.rb'

describe "Generate CSV files from the commit history" do

  before (:each) do
    @metrics_generator = MetricsGeneratorCsv.new(COMMIT_HISTORY_WINE_CHEESE)
  end

  it "Should be able to create the wonderful table (sorted on team)" do
    table = "Committer,Team,osaka,cpputest,Total
daniel,Cheese,1,0,1
basvodde,Wine,9,0,9
janne,Wine,0,7,7
"
    expect(@metrics_generator.create_commit_table_with_committers_and_repository_info).to eq table
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
    expect(@metrics_generator.create_commit_table_with_weeks_and_team_commits).to eq table
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
    expect(@metrics_generator.create_commit_table_with_week_and_repository_info).to eq table
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
    expect(@metrics_generator.create_commit_table_with_weeks_and_committers).to eq table
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
    expect(@metrics_generator.create_commit_table_with_weeks_and_committers("Wine")).to eq table
  end

end
