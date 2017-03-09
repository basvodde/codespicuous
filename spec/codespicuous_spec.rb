
describe "Codespicuous command line" do

  subject {Codespicuous.new}

  it "creates a configurator, collect data, and generate output" do
    expect(subject).to receive(:puts).with("Stage 1: Configuring")
    expect(subject).to receive(:puts).with("Stage 2: Collecting input data")
    expect(subject).to receive(:puts).with("Stage 3: Generating output")
    subject.run
  end
end

