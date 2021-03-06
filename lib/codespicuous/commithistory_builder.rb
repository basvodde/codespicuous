
class CommitHistoryBuilder

  def initialize
    @commit_history = CommitHistory.new
  end

  def build
    @commit_history
  end

  def in_repository(name)
    @current_repository = Repository.new(name, "")
    self
  end

  def commits_of(name)
    @author = name
    self
  end

  def of_team(name)
    @team = name
    self
  end

  def without_team
    @team = nil
    self
  end

  def at(date)
    @commit_date = date
    add_commit_to_history
    self
  end

  def times(number)
    (number-1).times {
      add_commit_to_history
    }
    self
  end

  def add_commit_to_history
    commit = Commit.new
    commit.author = @author
    commit.date = DateTime.parse(@commit_date)
    commit.repository = @current_repository
    @commit_history.add_commit(commit)
    @commit_history.add_team_member(@team, @author) if @team
  end
end

