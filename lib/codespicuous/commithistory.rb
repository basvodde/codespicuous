

class CommitHistory

  attr_reader :commits, :teams, :repositories, :committers

  def initialize
    @commits = Commits.new
    @teams = Teams.new
    @committers = teams.committers
    @repositories = Repositories.new
  end

  def configure(teams, repositories)
    @teams = teams
    @committers = teams.committers
    @repositories = repositories
  end

  def add_commit(commit)
    @commits.add(commit)
    committer(commit.author).add_commit(commit)
    @repositories.add(commit.repository)
    commit.repository.add_commit(commit)
  end

  def add_commits(commits)
    commits.each { |commit|
      add_commit(commit)
    }
  end

  def add_team_member(team, member)
    team = @teams.team(team)
    team.add_member(committer(member))
  end

  def committer(name)
    @committers.committer(name)
  end

  def repository(name)
    @repositories.repository(name)
  end

  def team(name)
    @teams.team(name)
  end

  def repository_names
    @repositories.repository_names
  end

  def amount_of_comitters
    @committers.amount
  end

  def amount_of_commits_for_team_in_week(team_name, week)
    @commits.inject(0) { |amount_of_commits, commit|
      amount_of_commits + ((commit.by_team_with_name?(team_name) && commit.in_week?(week)) ? 1 : 0)
    }
  end

  def earliest_commit_date
    @commits.earliest_commit_date
  end

  def latest_commit_date
    @commits.latest_commit_date
  end

  def == commit_history
    @commits == commit_history.commits
  end

end
