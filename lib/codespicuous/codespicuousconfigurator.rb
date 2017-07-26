require 'yaml'

class CodespicuousConfigurator


  attr_reader :options, :repositories, :repositories_to_check, :committers, :teams

  def initialize
    @options = default_options
    @options_filename = "codespicuous.yaml"

    @repositories = Repositories.new
    @repositories_to_check = Repositories.new

    @committers = Committers.new
    @teams = Teams.new
  end

  def default_options
    options = {}
    options["offline"] = false
    options
  end

  def configure
    configure_from_yaml
    postprocess_yaml_configuration
    find_alternative_configuration_files

    validate_configuration
  end

  def postprocess_yaml_configuration
    postprocess_yaml_configuration_repositories
    postprocess_yaml_configuration_committers
  end

  def find_alternative_configuration_files
    find_alternative_configuration_files_for_repositories
    find_alternative_configuration_files_for_committers
  end


  def configure_from_yaml
    return unless File.exist?(@options_filename)

    puts '** Configuring options with "codespicuous.yaml"'
    @options.merge!(YAML::load(File.read("codespicuous.yaml")))
  end

  def postprocess_yaml_configuration_repositories
    repositories_in_yaml = options["repositories"] || {}
    repositories_in_yaml.each { |name, url|
      @repositories.add(Repository.new(name, url))
    }

    names_of_repositories_to_check = options["repositories_to_check"]
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
      puts '** Error: No repositories configured in codespicuous.yaml'
      return false
    end
    true
  end

  def postprocess_yaml_configuration_committers
    teams = options["teams"] || []

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
