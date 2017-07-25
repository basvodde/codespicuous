
class Committer

  attr_reader :commits
  attr_accessor :username, :first_name, :last_name, :email, :team

  def initialize(username)
    @username = username
    @commits = Commits.new
  end

  def self.create_committer(login, firstname, lastname, email, team)
    committer = Committer.new(login)
    committer.first_name = firstname
    committer.last_name = lastname
    committer.email = email
    committer.team = team
    committer
  end

  def in_team_with_name?(team_name)
    @team.name == team_name
  end

  def add_commit commit
    @commits.add(commit)
    commit.committer = self
  end

  def amount_of_commits
    @commits.amount
  end

  def amount_of_commits_to_repository name
    @commits.amount_of_commits_to_repository name
  end

  def amount_of_weeks_committed_to_repository name
    @commits.amount_of_weeks_committed_in_repository(name)
  end

  def amount_of_commits_in_week(week_start)
    @commits.amount_of_commits_in_week(week_start)
  end

  def amount_of_commits_to_repository_in_week(name, week_start)
    @commits.amount_of_commits_to_repository_in_week(name, week_start)
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

  def committer(name)
    @committers[name] ||= Committer.new(name)
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

  def select(&block)
    @committers.values.select(&block)
  end

end

