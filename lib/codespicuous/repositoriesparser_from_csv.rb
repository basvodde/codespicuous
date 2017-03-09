
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
    @repositories.add(Repository.new(row["name"], row["url"]))
  end

  def repositories
    @repositories
  end
end
