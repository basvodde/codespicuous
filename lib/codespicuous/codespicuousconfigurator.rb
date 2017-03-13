

class CodespicuousConfigurator

  def config_repositories
    puts '** Configuring repositories with "repositories.csv"'
    RepositoriesParserFromCsv.new.parse(File.read("repositories.csv")).repositories
  end

  def config_participants
    puts '** Configuring participants with "participants.csv"'
    ParticipantsParserFromCsv.new.parse(File.read("participants.csv")).participants
  end

end
