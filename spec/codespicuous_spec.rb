
describe "Codespicuous command line" do

  subject {Codespicuous.new}

  it "creates a configurator, collect data, and generate output" do
    expect(subject).to receive(:puts).with("Stage 1: Configuring")
    expect(subject).to receive(:configure)
    expect(subject).to receive(:puts).with("Stage 2: Collecting input data")
    expect(subject).to receive(:collect)
    expect(subject).to receive(:puts).with("Stage 3: Generating output")
    expect(subject).to receive(:generate_output)
    subject.run
  end

  it "configures the config data" do
    configurator = CodespicuousConfigurator.new
    repositories = double(:repositories)
    options = double(:options)
    committers = double(:committers)
    expect(CodespicuousConfigurator).to receive(:new).and_return(configurator)
    expect(configurator).to receive(:config_options).and_return(options)
    expect(configurator).to receive(:config_repositories).and_return(repositories)
    expect(configurator).to receive(:config_committers).and_return(committers)

    subject.configure
    expect(subject.options).to eq options
    expect(subject.committers).to eq committers
    expect(subject.repositories).to eq repositories
  end

  it "collects the input data" do
    collector = SVNDataCollector.new
    commit_history = CommitHistory.new
    expect(SVNDataCollector).to receive(:new).and_return(collector)
    expect(collector).to receive(:options=).with(subject.options)
    expect(collector).to receive(:collect_commit_history).with(subject.repositories).and_return(commit_history)

    subject.collect

    expect(subject.commit_history).to eq commit_history
  end

  it "generates output" do
    generator = MetricsGenerator.new
    expect(MetricsGenerator).to receive(:new).and_return(generator)
    expect(generator).to receive(:generate).with(subject.commit_history)
    subject.generate_output
  end
end

