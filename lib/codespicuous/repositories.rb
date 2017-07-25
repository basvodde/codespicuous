

class SameRepositoriesWithDifferentCommitsError < Exception

end

class Repository

  attr_reader :commits
  attr_accessor :url, :name

  def initialize(name, url)
    @name = name
    @url = url
    @commits = Commits.new
  end

  def add_commit commit
    @commits.add(commit)
  end

  def amount_of_commits_in_week(week_start)
    @commits.amount_of_commits_to_repository_in_week(name, week_start)
  end

  def ==(repository)
    is_equal = @name == repository.name && @url == repository.url

    raise SameRepositoriesWithDifferentCommitsError.new if is_equal && @commits != repository.commits
    is_equal
  end
end

class Repositories

  attr_reader :repositories

  def initialize
    @repositories = {}
  end

  def add repository
    @repositories[repository.name] = repository
  end

  def repository name
    @repositories[name]
  end

  def repository_names
    @repositories.keys
  end

  def amount
    @repositories.size
  end

  def each
    @repositories.values.each { |repository|
      yield repository
    }
  end

  def empty?
    @repositories.empty?
  end

  def map(&block)
    @repositories.values.map(&block)
  end

  def [](index)
    @repositories.values[index]
  end

  def ==(repositories)
    @repositories == repositories.repositories
  end
end

