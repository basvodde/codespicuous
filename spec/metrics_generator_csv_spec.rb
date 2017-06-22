
describe "Generate CSV files from the commit history" do

  it "exists" do
    csv = MetricsGeneratorCsv.new
    commit_history = CommitHistory.new
    csv.generate(commit_history)
  end
end
