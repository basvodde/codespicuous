

class MetricsGenerator

  attr_accessor :commit_history

  def generate(commit_history)
    @commit_history = commit_history
    generate_daniel
    generate_csv
  end

  def generate_daniel
    daniel = MetricsGeneratorDaniel.new
    daniel.generate(@commit_history)
  end

  def generate_csv
    csv = MetricsGeneratorCsv.new
    csv.generate(@commit_history)
  end
end
