
require 'commithistories_data.rb'

describe "Generate CSV files from the commit history" do

  before (:each) do
    @commit_history = COMMIT_HISTORY_WINE_CHEESE
  end


  it "Should be able to create the wonderful table (sorted on team)" do
    table = "Committer,Team,osaka,cpputest,Total
daniel,Cheese,1,0,1
basvodde,Wine,9,0,9
janne,Wine,0,7,7
"
    metrics_generator = MetricsGeneratorCsv.new(@commit_history)
    expect(metrics_generator.create_commit_table_with_committers_and_repository_info).to eq table
  end

  it "exists" do
    #commit_history = CommitHistory.new
    #csv.generate(commit_history)
  end
end
