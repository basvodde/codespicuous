

class CodespicuousConfigurator

  attr_reader :repositories

  def config_repositories
    @repositories = RepositoriesParserFromCsv.new.parse(File.read("repositories.csv")).repositories
  end

end
