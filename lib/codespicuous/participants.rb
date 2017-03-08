

class Participant

  def initialize(loginname)
    @loginname = loginname
    @commits = Commits.new
  end

  def add_commit commit
    @commits.add(commit)
    commit.participant = self
  end

  def commits
    @commits
  end

  attr_accessor :loginname, :first_name, :last_name, :email, :team
end

class Participants

  def initialize(initial_participants_loginnames = [])
    @participants = {}

    [initial_participants_loginnames].flatten.each { |loginname|
      @participants[loginname] = Participant.new(loginname)
    }
  end

  def add(participant)
    @participants[participant.loginname] = participant
  end

  def amount
    @participants.size
  end

  def find_by_loginname loginname
    @participants[loginname]
  end

  def include? loginname
    @participants.keys.include?(loginname)
  end

end

