
describe "Daniel format metrics generator" do

  it "exists" do
    commit_history = CommitHistory.new
    daniel = MetricsGeneratorDaniel.new(commit_history)
    daniel.generate
  end

end
