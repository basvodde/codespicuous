

class Change

  def initialize
    @changed_property = false
  end

  attr_accessor :type, :file, :copyfrom, :copyrev

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

  attr_accessor :author, :revision, :message, :participant, :date, :changes, :repository
end

class Commits

  def initialize
    @commits = {}
  end

  def commits
    @commits.values
  end

  def amount
    @commits.size
  end

  def add_participants_commit(commit, participants)

    if participants.nil? or participants.include? commit.author
      add commit
      participants.find_by_loginname(commit.author).add_commit(commit) unless participants.nil?
    end
  end

  def each
    @commits.values.each { |commit|
      yield commit
    }
  end

  def add commit
      @commits[commit.revision] = commit
  end

  def add_commits commits
    commits.each { |commit|
      add commit
    }
  end

  def find_commit revision
    @commits[revision]
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
