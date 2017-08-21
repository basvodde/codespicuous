

class MetricsGenerator

  attr_accessor :commit_history, :config

  def generate(config, commit_history)
    @commit_history = commit_history
    @config = config
    generate_daniel
    generate_csv_files
  end

  def generate_daniel
    daniel = MetricsGeneratorDaniel.new(@config, @commit_history)
    daniel.generate
  end

  def generate_csv_files
    csv = MetricsGeneratorCsvFiles.new(@config, @commit_history)
    csv.generate
  end
end
