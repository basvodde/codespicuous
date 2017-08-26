
class Committer

  attr_reader :commits
  attr_accessor :username, :first_name, :last_name, :email, :team

  def initialize(username)
    @username = username
    @commits = Commits.new
  end

  def clone_without_commits
    cloned_committer = Committer.new(username)
    cloned_committer.first_name = first_name
    cloned_committer.last_name = last_name
    cloned_committer.email = email
    cloned_committer
  end

  def self.create_committer(login, firstname, lastname, email)
    committer = Committer.new(login)
    committer.first_name = firstname
    committer.last_name = lastname
    committer.email = email
    committer
  end

  def in_team_with_name?(team_name)
    !@team.nil? && @team.name == team_name
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

  def committed_repositories
    repositories = []
    commits.each do |commit|
      repositories.push(commit.repository)
    end
    repositories.uniq
  end

  def ==(committer)
    username == committer.username &&
    first_name == committer.first_name &&
    last_name == committer.last_name &&
    email == committer.email &&
    team.name == committer.team.name
  end

end

class Committers

  attr_reader :committers

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

  def each
    @committers.values.each do |committer|
      yield committer
    end
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

  def empty?
    @committers.empty?
  end

  def ==(committers)
    @committers == committers.committers
  end

end

