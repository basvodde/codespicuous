
describe "CodepicuousConfigurator reads all the config files and provides the data needed for running Codespicuous" do

  subject { CodespicuousConfigurator.new }

  it "Should process the yaml file" do
    expect(subject).to receive(:configure_from_yaml)
    expect(subject).to receive(:postprocess_yaml_configuration)
    expect(subject).to receive(:find_alternative_configuration_files)
    expect(subject).to receive(:validate_configuration)
    subject.configure
  end

  it "reads the codespicuous configuration from YAML file when the file exists" do
    expect(File).to receive(:exist?).with("codespicuous.yaml").and_return(true)
    expect(File).to receive(:read).with("codespicuous.yaml").and_return("offline: true")
    expect(subject).to receive(:puts).with('** Configuring options with "codespicuous.yaml"')
    expected_options = { "offline" => true }

    subject.configure_from_yaml
    expect(subject.options).to eq expected_options
  end

  it "Ignores the missing options file and tries to use defaults" do
    expected_options = { "offline" => false }
    expect(File).to receive(:exist?).with("codespicuous.yaml").and_return(false)

    subject.configure_from_yaml

    expect(subject.options).to eq expected_options
  end

  it "Processes the repositories out of the options with all selected" do
    repositories = Repositories.new
    repositories.add(Repository.new("name", "url"))

    expect(subject).to receive(:options).and_return({"repositories" => { "name" => "url"} })
    expect(subject).to receive(:options).and_return({})

    subject.postprocess_yaml_configuration

    expect(subject.repositories).to eq repositories
    expect(subject.repositories_to_check).to eq repositories
  end

  it "Processes the repositories out of the options, with only the selected one" do

    expect(subject).to receive(:options).and_return({"repositories" => { "name" => "url", "name2" => "url2"}})
    expect(subject).to receive(:options).and_return({"repositories_to_check" => ["name2"]})

    subject.postprocess_yaml_configuration

    repositories = Repositories.new
    repositories.add(Repository.new("name", "url"))
    repositories.add(Repository.new("name2", "url2"))

    checked_repositories = Repositories.new
    checked_repositories.add(Repository.new("name2", "url2"))

    expect(subject.repositories).to eq repositories
    expect(subject.repositories_to_check).to eq checked_repositories
  end

  it "will not bother checking the CSV file when it found repositories already" do
    expect(subject).to receive(:repositories).and_return({"name" => "url"})

    subject.find_alternative_configuration_files
  end

  it "will check whether there is a CSV file and continue if not found" do
    expect(File).to receive(:exist?).with("repositories.csv").and_return(false)

    subject.find_alternative_configuration_files

    expect(subject.repositories).to eq Repositories.new
  end

  it "will read the CSV file when it exists" do
    expect(File).to receive(:exist?).with("repositories.csv").and_return(true)
    expect(File).to receive(:read).with("repositories.csv").and_return("name,url\nrepos,https://repos.com")
    expect(subject).to receive(:puts).with('** Configuring repositories with "repositories.csv"')

    subject.find_alternative_configuration_files

    repositories = Repositories.new
    repositories.add(Repository.new("repos", "https://repos.com"))

    expect(subject.repositories).to eq repositories
  end

  it "reads the committers from file by default" do
    expect(File).to receive(:read).with("committers.csv").and_return("#,First Name,Last Name,Email,Login,Team,Specialization,Manager,day1,day2,day3,Comments,Present,Questionaire send,Answered,Pretest,Dietary,Commits,Blamed lines,Average LOC/Commit
1,Bas,Vodde,basv@wow.com,basvodde,Wine")
    expect(subject).to receive(:puts).with('** Configuring committers with "committers.csv"')

    expect(subject.config_committers.include?("basvodde")).to be true
  end
end

