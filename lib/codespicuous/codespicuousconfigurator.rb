require 'yaml'

class CodespicuousConfigurator


  attr_reader :options, :repositories, :repositories_to_check, :committers

  def initialize
    @options = default_options
    @options_filename = "codespicuous.yaml"
    @repositories = Repositories.new
    @repositories_to_check = Repositories.new
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

  def configure_from_yaml
    return unless File.exist?(@options_filename)

    puts '** Configuring options with "codespicuous.yaml"'
    @options.merge!(YAML::load(File.read("codespicuous.yaml")))
  end

  def postprocess_yaml_configuration
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

  def find_alternative_configuration_files
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

  def config_committers
    puts '** Configuring committers with "committers.csv"'
    CommittersParserFromCsv.new.parse(File.read("committers.csv")).committers
  end

end
