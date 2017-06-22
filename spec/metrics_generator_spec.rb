
describe "Generate different types of code metrics" do

  before (:each) do
    @commit_history = CommitHistory.new
    @subject = MetricsGenerator.new
  end

  it "can generate different metrics" do
    expect(@subject).to receive(:generate_daniel)
    expect(@subject).to receive(:generate_csv)

    @subject.generate(@commit_history)
  end

  it "generate daniel format metrics" do
    @subject.commit_history = @commit_history

    daniel = MetricsGeneratorDaniel.new
    expect(MetricsGeneratorDaniel).to receive(:new).and_return(daniel)
    expect(daniel).to receive(:generate).with(@commit_history)

    @subject.generate_daniel
  end

  it "generate csv format metrics" do
    @subject.commit_history = @commit_history

    csv = MetricsGeneratorCsv.new
    expect(MetricsGeneratorCsv).to receive(:new).and_return(csv)
    expect(csv).to receive(:generate).with(@commit_history)

    @subject.generate_csv
  end
end
