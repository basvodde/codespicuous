

class ParticipantsParserFromCsv

  def initialize
    @participants = Participants.new
    @teams = Teams.new
  end

  def parse csv_string
    CSV.parse(csv_string, headers: true) { |row|
      parse_row row
    }
    self
  end

  def parse_row row
      participant = Participant.new(row["Login"])
      participant.first_name = row["First Name"]
      participant.last_name = row["Last Name"]
      participant.email = row["Email"]
      team = @teams.team(row["Team"])
      participant.team = team
      team.add_member(participant)
      @participants.add(participant)
  end

  def participants
    @participants
  end

  def teams
    @teams
  end
end


