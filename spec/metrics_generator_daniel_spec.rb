
describe "Daniel format metrics generator" do

  it "exists" do
    commit_history = CommitHistory.new
    config = CodespicuousConfig.new
    daniel = MetricsGeneratorDaniel.new(config, commit_history)
    daniel.generate
  end

end
