
class RepositoriesParserFromCsv

  def initialize
    @repositories = Repositories.new
  end

  def parse csv_string
    CSV.parse(csv_string, headers: true) { |row|
      parse_row row
    }
    self
  end

  def parse_row row
    repository = Repository.new(row["name"])
    repository.url = row["url"]
    @repositories.add(repository)
  end

  def repositories
    @repositories
  end
end
