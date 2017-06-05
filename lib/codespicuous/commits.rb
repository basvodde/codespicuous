

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

  def initialize
    @commits = {}
    @committers = {}
  end

  def commits
    @commits.values
  end

  def [] revision
    commits[revision]
  end

  def amount
    @commits.size
  end

  def each
    @commits.values.each { |commit|
      yield commit
    }
  end

  def add commit
      @commits[commit.revision] = commit

      if commit.committer.nil?
        @committers[commit.author] ||= Committer.new(commit.author)
        commit.committer = @committers[commit.author]
        commit.committer.add_commit(commit)
      end

  end

  def add_commits commits
    commits.each { |commit|
      add commit
    }
  end

  def find_commit revision
    @commits[revision]
  end

  def find_by_committer name
    @committers[name].commits
  end

  def set_repository(repository)
    each { |commit|
      commit.repository = repository
    }
  end

  def == commits
    @commits.values == commits.commits
  end

  def +(commits)
    result = Commits.new
    result.add_commits(self)
    result.add_commits(commits)
    result
  end
end
