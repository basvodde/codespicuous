
class Codespicuous

  attr_reader :repositories, :commits

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
    @repositories = configurator.config_repositories
  end

  def collect
    collector = SVNDataCollector.new
    @commits = collector.collect_commits(repositories)
  end

  def generate_output

  end

end
