

class CommittersParserFromCsv

  def initialize
    @committers = Committers.new
    @teams = Teams.new
  end

  def parse csv_string
    CSV.parse(csv_string, headers: true) { |row|
      parse_row row
    }
    self
  end

  def parse_row row
      committer = Committer.new(row["Login"])
      committer.first_name = row["First Name"]
      committer.last_name = row["Last Name"]
      committer.email = row["Email"]
      team = @teams.team(row["Team"])
      committer.team = team
      team.add_member(committer)
      @committers.add(committer)
  end

  def committers
    @committers
  end

  def teams
    @teams
  end
end


