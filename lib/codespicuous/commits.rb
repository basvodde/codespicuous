

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

  def by_team_with_name?(team_name)
    committer.in_team_with_name?(team_name)
  end

  def in_week?(date)
    @date.cwyear == date.cwyear && @date.cweek == date.cweek
  end
end

class Commits

  attr_reader :commits

  def initialize(commits = [])
    @commits = commits
  end

  def [] index
    @commits[index]
  end

  def each
    @commits.each { |commit|
      yield commit
    }
  end

  def inject(value, &block)
    @commits.inject(value, &block)
  end

  def commits_in_repository(name)
    @commits.select { |commit| commit.repository.name == name }
  end

  def add commit
    @commits << commit
  end

  def add_commits commits
    commits.each { |commit|
      add commit
    }
  end

  def set_repository(repository)
    each { |commit|
      commit.repository = repository
    }
  end

  def find_commit(repository, revision)
    @commits.find { |commit| commit.repository == repository && commit.revision == revision}
  end

  def find_by_committer name
    Commits.new (@commits.select { |commit| commit.author == name })
  end

  def earliest_commit_date
    @commits.inject(DateTime.now) { |date, commit| date < commit.date ? date : commit.date }
  end

  def latest_commit_date
    @commits.inject(DateTime.new(1977)) { |date, commit| date > commit.date ? date : commit.date }
  end

  def amount
    @commits.size
  end

  def amount_of_commits_to_repository(name)
    commits_in_repository(name).size
  end

  def amount_of_weeks_committed_in_repository(name)
    commits_in_repository(name).collect { |commit| [commit.date.cwyear, commit.date.cweek]}.uniq.size
  end

  def amount_of_commits_in_week(week_start)
    @commits.select { |commit| commit.in_week?(week_start)}.size
  end

  def amount_of_commits_to_repository_in_week(name, week_start)
    commits_in_repository(name).select { |commit|
      commit.in_week?(week_start)
    }.size
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
