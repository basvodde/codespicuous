
require 'optparse'

class Codespicuous

  attr_reader :repositories, :commit_history, :committers, :options

  def run(argv)
    parse_options(argv)

    if @options[:repositories]
      run_which_repositories
    else
      run_codespicuous
    end
  end

  def parse_options(argv)
    @options = {}

    parser = OptionParser.new do | opts |
      @options[:repositories] = false

      opts.on('-r', '--repositories', "List the repositories the team committed to") do
        @options[:repositories] = true
      end

    end

    parser.parse!(argv)
  end

  def run_which_repositories

    puts "Stage 1: Configuring"
    return false unless configure

    puts "Stage 2: Collecting input data"
    collect

    puts "Stage 3: Listing repositories committed to"
    list_committed_repositories

    true
  end

  def run_codespicuous

    puts "Stage 1: Configuring"
    return false unless configure

    puts "Stage 2: Collecting input data"
    collect

    puts "Stage 3: Generating output"
    generate_output

    true
  end

  def configure
    configurator = CodespicuousConfigurator.new
    return false unless configurator.configure

    @options = configurator.options
    @repositories = configurator.repositories
    @committers = configurator.committers

    true
  end

  def collect
    collector = SVNDataCollector.new
    collector.options = options
    @commit_history = collector.collect_commit_history(repositories)
  end

  def generate_output
    generator = MetricsGenerator.new
    generator.generate(@commit_history)
  end

  def list_committed_repositories
    lister = RepositoryLister.new
    lister.list(@commit_history)
  end
end
