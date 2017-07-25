
class Codespicuous

  attr_reader :repositories, :commit_history, :committers, :options

  def run
    puts "Stage 1: Configuring"
    configure
    puts "Stage 2: Collecting input data"
    collect
    puts "Stage 3: Generating output"
    generate_output
  end

  def configure
    configurator = CodespicuousConfigurator.new
    configurator.configure
    @options = configurator.options
    @repositories = configurator.repositories
    @committers = configurator.committers
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

end
