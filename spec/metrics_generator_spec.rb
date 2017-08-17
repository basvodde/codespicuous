
describe "Generate different types of code metrics" do

  before (:each) do
    @commit_history = CommitHistory.new
    @subject = MetricsGenerator.new
  end

  it "can generate different metrics" do
    expect(@subject).to receive(:generate_daniel)
    expect(@subject).to receive(:generate_csv_files)

    @subject.generate(@commit_history)
  end

  it "generate daniel format metrics" do
    @subject.commit_history = @commit_history

    daniel = MetricsGeneratorDaniel.new(@commit_history)
    expect(MetricsGeneratorDaniel).to receive(:new).with(@commit_history).and_return(daniel)
    expect(daniel).to receive(:generate)

    @subject.generate_daniel
  end

  it "generate csv format metrics" do
    @subject.commit_history = @commit_history

    csv = MetricsGeneratorCsvFiles.new(@commit_history)
    expect(MetricsGeneratorCsvFiles).to receive(:new).with(@commit_history).and_return(csv)
    expect(csv).to receive(:generate)

    @subject.generate_csv_files
  end
end
