
describe "Codespicuous command line" do

  subject {Codespicuous.new}

  it "parses the options and can search for repositories committed to" do
    expect(subject).to receive(:run_which_repositories)
    expect(subject).not_to receive(:run_codespicuous)

    subject.run(["-r"])
  end

  it "prints an error message when no config it present" do
    expect(subject).to receive(:puts).with("Stage 1: Configuring")
    expect($stdout).to receive(:puts).with("** Error: No repositories configured in codespicuous.yaml")

    expect(subject.run([])).to eq false
  end

  it "creates a configurator, collect data, and lists the repositories the people committed to" do
    expect(subject).to receive(:puts).with("Stage 1: Configuring")
    expect(subject).to receive(:configure).and_return(true)
    expect(subject).to receive(:puts).with("Stage 2: Collecting input data")
    expect(subject).to receive(:collect)
    expect(subject).to receive(:puts).with("Stage 3: Listing repositories committed to")
    expect(subject).to receive(:list_committed_repositories)

    expect(subject.run_which_repositories).to eq true
  end

  it "creates a configurator, collect data, and generate output" do
    expect(subject).to receive(:puts).with("Stage 1: Configuring")
    expect(subject).to receive(:configure).and_return(true)
    expect(subject).to receive(:puts).with("Stage 2: Collecting input data")
    expect(subject).to receive(:collect)
    expect(subject).to receive(:puts).with("Stage 3: Generating output")
    expect(subject).to receive(:generate_output)

    expect(subject.run_codespicuous).to eq true
  end

  it "configures the config data" do
    configurator = CodespicuousConfigurator.new
    repositories = double(:repositories)
    options = double(:options)
    committers = double(:committers)
    expect(CodespicuousConfigurator).to receive(:new).and_return(configurator)
    expect(configurator).to receive(:configure).and_return(true)
    expect(configurator).to receive(:options).and_return(options)
    expect(configurator).to receive(:repositories).and_return(repositories)
    expect(configurator).to receive(:committers).and_return(committers)

    subject.configure
    expect(subject.options).to be options
    expect(subject.committers).to be committers
    expect(subject.repositories).to be repositories
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

  it "lists the repositories" do
    lister = RepositoryLister.new
    expect(RepositoryLister).to receive(:new).and_return(lister)
    expect(lister).to receive(:list).with(subject.commit_history)
    subject.list_committed_repositories
  end
end

