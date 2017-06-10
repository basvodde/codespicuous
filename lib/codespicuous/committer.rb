
class Committer

  attr_reader :commits
  attr_accessor :username, :first_name, :last_name, :email, :team

  def initialize(username)
    @username = username
    @commits = Commits.new
  end

  def add_commit commit
    @commits.add(commit)
    commit.committer = self
  end
end

class Committers

  def initialize(initial_committers_usernames = [])
    @committers = {}

    [initial_committers_usernames].flatten.each { |username|
      @committers[username] = Committer.new(username)
    }
  end

  def add(committer)
    @committers[committer.username] = committer
  end

  def amount
    @committers.size
  end

  def find_by_username username
    @committers[username]
  end

  def include? username
    @committers.keys.include?(username)
  end
end

