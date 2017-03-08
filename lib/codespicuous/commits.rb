

class Change
  attr_accessor :type, :file
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

  def amount
    @commits.size
  end

  def add_participants_commit(commit, participants)
    return unless participants.include? commit.author

    add commit
    participants.find_by_loginname(commit.author).add_commit(commit)
  end

  def add commit
    @commits[commit.revision] = commit
  end

  def find_commit revision
    @commits[revision]
  end
end
