

class Change

  def initialize
    @changed_property = false
  end

  attr_accessor :type, :file, :copyfrom, :copyrev, :kind

  def changed_property?
    @changed_property
  end

  def property_changed
    @changed_property = true
  end
end

class Commit

  def initialize
    @changes = []
  end

  attr_accessor :author, :revision, :message, :date, :changes, :repository, :committer
end

class Commits

  attr_reader :commits

  def initialize(commits = [])
    @commits = commits
  end

  def amount
    @commits.size
  end

  def [] index
    @commits[index]
  end

  def each
    @commits.each { |commit|
      yield commit
    }
  end

  def add commit
    @commits << commit
  end

  def add_commits commits
    commits.each { |commit|
      add commit
    }
  end

  def find_commit(repository, revision)
    @commits.find { |commit| commit.repository == repository && commit.revision == revision}
  end

  def find_by_committer name
    Commits.new (@commits.select { |commit| commit.author == name })
  end

  def set_repository(repository)
    each { |commit|
      commit.repository = repository
    }
  end

  def == commits
    @commits == commits.commits
  end

  def +(commits)
    result = Commits.new
    result.add_commits(self)
    result.add_commits(commits)
    result
  end
end
