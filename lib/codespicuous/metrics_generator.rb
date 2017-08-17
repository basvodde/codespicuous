

class MetricsGenerator

  attr_accessor :commit_history

  def generate(commit_history)
    @commit_history = commit_history
    generate_daniel
    generate_csv_files
  end

  def generate_daniel
    daniel = MetricsGeneratorDaniel.new(@commit_history)
    daniel.generate
  end

  def generate_csv_files
    csv = MetricsGeneratorCsvFiles.new(@commit_history)
    csv.generate
  end
end
