require 'yaml'

class CodespicuousConfigurator


  attr_reader :repositories, :repositories_to_check, :committers, :teams, :config

  def initialize(config)

    @config = config

    @repositories = Repositories.new
    @repositories_to_check = Repositories.new

    @committers = Committers.new
    @teams = Teams.new
  end

  def configure(argv)

    parse_command_line_arguments(argv)

    yaml_content = configure_from_yaml
    postprocess_yaml_configuration(yaml_content)

    find_alternative_configuration_files

    validate_configuration
  end

  def parse_command_line_arguments(argv)

    parser = OptionParser.new do | opts |
      opts.on('-r', '--repositories', "List the repositories the team committed to") do
      @config.list_repositories = true
      end

    end

    parser.parse!(argv)
  end

  def postprocess_yaml_configuration(yaml_content)
    postprocess_yaml_configuration_repositories(yaml_content)
    postprocess_yaml_configuration_committers(yaml_content)
  end

  def find_alternative_configuration_files
    find_alternative_configuration_files_for_repositories
    find_alternative_configuration_files_for_committers
  end

  def configure_from_yaml
    return {} unless File.exist?(config.path_to_configuration_file)

    puts "** Configuring options with \"#{config.path_to_configuration_file}\""
    yaml_content = YAML::load(File.read(config.path_to_configuration_file))
    config.offline = yaml_content["offline"] if yaml_content["offline"]
    yaml_content
  end

  def postprocess_yaml_configuration_repositories(yaml_content)
    repositories_in_yaml = yaml_content["repositories"] || {}
    repositories_in_yaml.each { |name, url|
      @repositories.add(Repository.new(name, url))
    }

    names_of_repositories_to_check = yaml_content["repositories_to_check"]
    if (names_of_repositories_to_check)
      @repositories.each { |repository|
        @repositories_to_check.add(repository) if names_of_repositories_to_check.include?(repository.name)
      }
    else
      @repositories_to_check = @repositories
    end
  end

  def find_alternative_configuration_files_for_repositories
    return unless repositories.empty?
    return unless File.exist?("repositories.csv")

    puts '** Configuring repositories with "repositories.csv"'

    CSV.parse(File.read("repositories.csv"), headers: true) { |row|
      @repositories.add(Repository.new(row["name"], row["url"]))
    }
  end

  def validate_configuration
    if @repositories.empty?
      puts "** Error: No repositories configured in \"#{config.path_to_configuration_file}\""
      return false
    end
    true
  end

  def postprocess_yaml_configuration_committers(yaml_content)
    teams = yaml_content["teams"] || []

    teams.each { |team_name, team_members|
      new_team = Team.new(team_name)
      team_members.each { |person|
        committer = Committer.create_committer(person["Login"], person["First Name"], person["Last Name"], person["Email"], new_team)
        new_team.add_member(committer)
        @committers.add(committer)
        @teams.add(new_team)
      }
    }
  end

  def find_alternative_configuration_files_for_committers
    return unless committers.empty?
    return unless File.exist?("committers.csv")

    puts '** Configuring committers with "committers.csv"'

    @committers = Committers.new
    @teams = Teams.new

    CSV.parse(File.read("committers.csv"), headers: true) { |row|
      team = @teams.team(row["Team"])
      committer = Committer.create_committer(row["Login"], row["First Name"], row["Last Name"], row["Email"], team)
      team.add_member(committer)
      @committers.add(committer)
    }
    @committers
  end

end
