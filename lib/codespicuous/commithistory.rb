

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

  def amount_of_repositories
    @repositories.amount
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

  def copy_repositories_without_commits
    repositories = Repositories.new
    @repositories.each do |repository|
      repositories.add(repository.clone_without_commits)
    end
    repositories
  end

  def prune_repositories_without_commit
    @repositories.prune_repositories_without_commit
  end

  def restrict_to_teams
    restricted_commit_history = CommitHistory.new

    repositories = copy_repositories_without_commits
    restricted_commit_history.configure(teams.clone_without_commits, repositories)

    @commits.each do |commit|
      if @teams.contains_committer?(commit.committer)
        new_commit = commit.clone
        new_commit.repository = repositories.repository(commit.repository.name)
        restricted_commit_history.add_commit(new_commit)
      end

    end

    restricted_commit_history.prune_repositories_without_commit

    restricted_commit_history
  end

end
