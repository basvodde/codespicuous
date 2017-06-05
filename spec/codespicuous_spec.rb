
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
    participants = double(:participants)
    expect(CodespicuousConfigurator).to receive(:new).and_return(configurator)
    expect(configurator).to receive(:config_options).and_return(options)
    expect(configurator).to receive(:config_repositories).and_return(repositories)
    expect(configurator).to receive(:config_participants).and_return(participants)

    subject.configure
    expect(subject.options).to eq options
    expect(subject.participants).to eq participants
    expect(subject.repositories).to eq repositories
  end

  it "collects the input data" do
    collector = SVNDataCollector.new
    commits = Commits.new
    expect(SVNDataCollector).to receive(:new).and_return(collector)
    expect(collector).to receive(:collect_commits).with(subject.repositories, subject.options).and_return(commits)

    subject.collect

    expect(subject.commits).to eq commits
  end
end

