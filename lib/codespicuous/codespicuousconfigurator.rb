

class CodespicuousConfigurator

  def config_repositories
    puts '** Configuring repositories with "repositories.csv"'
    RepositoriesParserFromCsv.new.parse(File.read("repositories.csv")).repositories
  end

end
