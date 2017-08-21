
describe "Generate different types of code metrics" do

  before (:each) do
    @commit_history = CommitHistory.new
    @config = CodespicuousConfig.new
    @subject = MetricsGenerator.new

    @subject.commit_history = @commit_history
    @subject.config = @config
  end

  it "can generate different metrics" do
    expect(@subject).to receive(:generate_daniel)
    expect(@subject).to receive(:generate_csv_files)

    @subject.generate(@config, @commit_history)
  end

  it "generate daniel format metrics" do

    daniel = MetricsGeneratorDaniel.new(@config, @commit_history)
    expect(MetricsGeneratorDaniel).to receive(:new).with(@config, @commit_history).and_return(daniel)
    expect(daniel).to receive(:generate)

    @subject.generate_daniel
  end

  it "generate csv format metrics" do
    @subject.commit_history = @commit_history

    csv = MetricsGeneratorCsvFiles.new(@config, @commit_history)
    expect(MetricsGeneratorCsvFiles).to receive(:new).with(@config, @commit_history).and_return(csv)
    expect(csv).to receive(:generate)

    @subject.generate_csv_files
  end
end
