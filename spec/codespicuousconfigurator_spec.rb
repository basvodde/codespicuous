
describe "CodepicuousConfigurator reads all the config files and provides the data needed for running Codespicuous" do

  it "reads the repositories from file by default" do
    configurator = CodespicuousConfigurator.new
    expect(File).to receive(:read).with("repositories.csv").and_return("name,url\nrepos,https://repos.com")
    expect(configurator).to receive(:puts).with('** Configuring repositories with "repositories.csv"')
    expect(configurator.config_repositories.repository_by_name("repos").url).to eq "https://repos.com"
  end
end
