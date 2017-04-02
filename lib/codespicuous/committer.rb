

class Committer

  attr_reader :commits

  def initialize(name)
    @username = name
    @commits = Commits.new
  end

  def add_commit(commit)
    @commits.add(commit)
  end

end
