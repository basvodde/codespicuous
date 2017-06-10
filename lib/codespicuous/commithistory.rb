

class CommitHistory

  attr_reader :commits

  def initialize(commits = Commits.new)
    @commits = Commits.new
    @committers = {}
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

  def committer(name)
    @committers[name] ||= Committer.new(name)
  end

  def amount_of_comitters
    @committers.size
  end

  def == commit_history
    @commits == commit_history.commits
  end
end
