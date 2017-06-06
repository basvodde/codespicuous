

class CommitHistory

  attr_reader :commits

  def initialize(commits = Commits.new)
    @commits = Commits.new
    add_commits(commits)
  end

  def add_commits(commits)
    @commits += commits
  end

  def == commit_history
    @commits == commit_history.commits
  end
end
