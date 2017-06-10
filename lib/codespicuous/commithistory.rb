

class CommitHistory

  attr_reader :commits, :teams

  def initialize(commits = Commits.new)
    @commits = Commits.new
    @committers = Committers.new
    @teams = Teams.new
    add_commits(commits)
  end

  def add_commit(commit)
    @commits.add(commit)
    committer(commit.author).add_commit(commit)
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

  def amount_of_comitters
    @committers.amount
  end

  def == commit_history
    @commits == commit_history.commits
  end
end
