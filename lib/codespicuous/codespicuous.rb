
require 'optparse'

class Codespicuous

  attr_reader :repositories, :commit_history, :committers, :teams, :config

  def initialize
    @config = CodespicuousConfig.new
    @commit_history = CommitHistory.new
  end

  def run(argv)

    puts "Stage 1: Configuring"
    return false unless configure(argv)

    puts "Stage 2: Collecting input data"
    collect

    if @config.list_repositories
      puts "Stage 3: Listing repositories committed to"
      list_committed_repositories
    else
      puts "Stage 3: Generating output"
      generate_output
    end
    true
  end

  def configure(argv)
    configurator = CodespicuousConfigurator.new(@config)
    return false unless configurator.configure(argv)

    @commit_history.configure(configurator.teams, configurator.repositories)

    true
  end

  def collect
    collector = SVNDataCollector.new(config, @commit_history)
    collector.collect_commit_history(@commit_history.repositories)
  end

  def generate_output
    generator = MetricsGenerator.new
    generator.generate(@config, @commit_history)
  end

  def list_committed_repositories
    repository_lister = RepositoryLister.new
    repository_lister.list(@commit_history)
  end
end
