
describe "Daniel format metrics generator" do

  it "exists" do
    daniel = MetricsGeneratorDaniel.new
    commit_history = CommitHistory.new
    daniel.generate(commit_history)
  end

end
