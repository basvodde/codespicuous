require 'yaml'

class CodespicuousConfigurator

  def default_options
    options = {}
    options["offline"] = false
    options
  end

  def config_options
    options = default_options
    options.merge!(YAML::load(File.read("codespicuous.yaml")))
    puts '** Configuring options with "codespicuous.yaml"'
    options
  rescue Errno::ENOENT
    default_options
  end

  def config_repositories
    puts '** Configuring repositories with "repositories.csv"'
    RepositoriesParserFromCsv.new.parse(File.read("repositories.csv")).repositories
  end

  def config_participants
    puts '** Configuring participants with "participants.csv"'
    ParticipantsParserFromCsv.new.parse(File.read("participants.csv")).participants
  end

end
