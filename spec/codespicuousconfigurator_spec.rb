
describe "CodepicuousConfigurator reads all the config files and provides the data needed for running Codespicuous" do

  subject { CodespicuousConfigurator.new(CodespicuousConfig.new) }

  it "Should process the yaml file" do
    expect(subject).to receive(:parse_command_line_arguments).with(["argv"])
    expect(subject).to receive(:configure_from_yaml)
    expect(subject).to receive(:postprocess_yaml_configuration)
    expect(subject).to receive(:find_alternative_configuration_files)
    expect(subject).to receive(:validate_configuration)
    subject.configure(["argv"])
  end

  it "should be able to handle the -r command line option" do
    subject.parse_command_line_arguments(["-r"])
    expect(subject.config.list_repositories).to be true
  end

  it "Should be able to handle the -i command line option for input directory " do
    subject.parse_command_line_arguments(["-i", "blah"])
    expect(subject.config.input_path).to eq Pathname.new("blah")
  end

  it "Should post process the YAML file" do
    yaml_content = {}

    expect(subject).to receive(:postprocess_yaml_configuration_repositories).with(yaml_content)
    expect(subject).to receive(:postprocess_yaml_configuration_committers).with(yaml_content)

    subject.postprocess_yaml_configuration(yaml_content)
  end

  it "Should find alternative config files" do
    expect(subject).to receive(:find_alternative_configuration_files_for_repositories)
    expect(subject).to receive(:find_alternative_configuration_files_for_committers)

    subject.find_alternative_configuration_files
  end

  context "Read the YAML file" do

    it "reads the codespicuous configuration from YAML file when the file exists" do
      expect(File).to receive(:exist?).with("codespicuous.yaml").and_return(true)
      expect(File).to receive(:read).with("codespicuous.yaml").and_return("offline: true")
      expect(subject).to receive(:puts).with('** Configuring options with "codespicuous.yaml"')

      subject.configure_from_yaml
      expect(subject.config.offline).to eq true
    end

    it "Ignores the missing options file and tries to use defaults" do
      expect(File).to receive(:exist?).with("codespicuous.yaml").and_return(false)

      subject.configure_from_yaml

      expect(subject.config.offline).to eq false
    end
  end

  context "Parsing the repositories" do

    it "Processes the repositories out of the options with all selected" do

      yaml_content = {"repositories" => { "name" => "url"}}

      subject.postprocess_yaml_configuration_repositories(yaml_content)

      repositories = Repositories.new
      repositories.add(Repository.new("name", "url"))

      expect(subject.repositories).to eq repositories
      expect(subject.repositories_to_check).to eq repositories
    end

    it "Processes the repositories out of the options, with only the selected one" do

      yaml_content = {"repositories" => { "name" => "url", "name2" => "url2"},
                      "repositories_to_check" => ["name2"]}

      subject.postprocess_yaml_configuration_repositories(yaml_content)

      repositories = Repositories.new
      repositories.add(Repository.new("name", "url"))
      repositories.add(Repository.new("name2", "url2"))

      checked_repositories = Repositories.new
      checked_repositories.add(Repository.new("name2", "url2"))

      expect(subject.repositories).to eq repositories
      expect(subject.repositories_to_check).to eq checked_repositories
    end

    it "will not bother checking the CSV file when it found repositories already" do
      repositories = Repositories.new
      repositories.add(Repository.new("name", "url"))
      expect(subject).to receive(:repositories).and_return(repositories)
      expect(File).not_to receive(:exist?)

      subject.find_alternative_configuration_files_for_repositories
    end

    it "will check whether there is a CSV file and continue if not found" do
      expect(File).to receive(:exist?).with("repositories.csv").and_return(false)

      subject.find_alternative_configuration_files_for_repositories

      expect(subject.repositories).to eq Repositories.new
    end

    it "will read the CSV file when it exists" do
      expect(File).to receive(:exist?).with("repositories.csv").and_return(true)
      expect(File).to receive(:read).with("repositories.csv").and_return("name,url\nrepos,https://repos.com")
      expect(subject).to receive(:puts).with('** Configuring repositories with "repositories.csv"')

      subject.find_alternative_configuration_files_for_repositories

      repositories = Repositories.new
      repositories.add(Repository.new("repos", "https://repos.com"))

      expect(subject.repositories).to eq repositories
    end
  end

  context "Parsing the teams and committers" do

    before (:each) do
      @team_wine = Team.new("Wine")
      @committer_bas = Committer.create_committer("basvodde", "Bas", "Vodde", "basv@wow.com", @team_wine)
    end

    it "can have no committers and teams. Just empty then" do
      subject.postprocess_yaml_configuration_committers({})

      expect(subject.committers).to eq Committers.new
      expect(subject.teams).to eq Teams.new
    end

    it "can get the team info from the yaml file" do

      yaml_content = {"teams" =>
                        {"Wine" => [{
                          "First Name" => "Bas",
                          "Last Name" => "Vodde",
                          "Email" => "basv@wow.com",
                          "Login" => "basvodde" } ]
                          } }

      subject.postprocess_yaml_configuration_committers(yaml_content)

      committers = Committers.new
      @team_wine.add_member(@committer_bas)
      committers.add(@committer_bas)

      teams = Teams.new
      teams.add(@team_wine)

      expect(subject.committers).to eq committers
      expect(subject.teams).to eq teams

    end

    it "will not bother checking the CSV file when it found committers already" do
      committers = Committers.new
      committers.add(@committer_bas)
      expect(subject).to receive(:committers).and_return(committers)
      expect(File).not_to receive(:exist?)

      subject.find_alternative_configuration_files_for_committers
    end

    it "will check whether there is a CSV file and continue if not found" do
      expect(File).to receive(:exist?).with("committers.csv").and_return(false)

      subject.find_alternative_configuration_files_for_committers

      expect(subject.committers).to eq Committers.new
    end

    it "will read the CSV file when it exists" do
      expect(File).to receive(:exist?).with("committers.csv").and_return(true)
      expect(File).to receive(:read).with("committers.csv").and_return("#,First Name,Last Name,Email,Login,Team,Specialization,Manager,day1,day2,day3,Comments,Present,Questionaire send,Answered,Pretest,Dietary,Commits,Blamed lines,Average LOC/Commit
#1,Bas,Vodde,basv@wow.com,basvodde,Wine")
      expect(subject).to receive(:puts).with('** Configuring committers with "committers.csv"')

      subject.find_alternative_configuration_files_for_committers

      committers = Committers.new
      committers.add(@committer_bas)

      expect(subject.committers).to eq committers
    end

  end

end

