
describe "CodepicuousConfigurator reads all the config files and provides the data needed for running Codespicuous" do

  subject { CodespicuousConfigurator.new }

  it "reads the codespicuous configuration from YAML file when the file exists" do
    expect(File).to receive(:read).with("codespicuous.yaml").and_return("option: setting")
    expect(subject).to receive(:puts).with('** Configuring options with "codespicuous.yaml"')
    expected = { "option" => "setting" }
    expect(subject.config_options).to eq expected
  end

  it "Ignores the missing options file and tries to use defaults" do
    expect(subject.config_options).to be_empty
  end

  it "reads the repositories from file by default" do
    expect(File).to receive(:read).with("repositories.csv").and_return("name,url\nrepos,https://repos.com")
    expect(subject).to receive(:puts).with('** Configuring repositories with "repositories.csv"')
    expect(subject.config_repositories.repository_by_name("repos").url).to eq "https://repos.com"
  end

  it "reads the participants from file by default" do
    expect(File).to receive(:read).with("participants.csv").and_return("#,First Name,Last Name,Email,Login,Team,Specialization,Manager,day1,day2,day3,Comments,Present,Questionaire send,Answered,Pretest,Dietary,Commits,Blamed lines,Average LOC/Commit
1,Bas,Vodde,basv@wow.com,basvodde,Wine")
    expect(subject).to receive(:puts).with('** Configuring participants with "participants.csv"')
    expect(subject.config_participants.include?("basvodde")).to be true
  end
end
