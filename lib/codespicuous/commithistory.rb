

class CommitHistory

  include DateUtil

  attr_reader :commits, :teams

  def initialize(commits = Commits.new)
    @commits = Commits.new
    @committers = Committers.new
    @teams = Teams.new
    @repositories = Repositories.new
    add_commits(commits)
  end

  def add_commit(commit)
    @commits.add(commit)
    committer(commit.author).add_commit(commit)
    @repositories.add(commit.repository)
    commit.repository.add_commit(commit)
  end

  def add_commits(commits)
    commits.each { |commit|
      add_commit(commit)
    }
  end

  def add_team_member(team, member)
    team = @teams.team(team)
    team.add_member(committer(member))
  end

  def committer(name)
    @committers.committer(name)
  end

  def repository(name)
    @repositories.repository(name)
  end

  def team(name)
    @teams.team(name)
  end

  def repository_names
    @repositories.repository_names
  end

  def amount_of_comitters
    @committers.amount
  end

  def amount_of_commits_for_team_in_week(team_name, week)
    @commits.inject(0) { |amount_of_commits, commit|
      amount_of_commits + ((commit.by_team_with_name?(team_name) && commit.in_week?(week)) ? 1 : 0)
    }
  end

  def create_commit_table_row_for_committer_with_repository_info committer
    [committer.username, committer.team.name, repository_names.map { |repository|
      committer.amount_of_commits_to_repository(repository)}, committer.amount_of_commits].flatten
  end

  def create_commit_table_rows_with_committers_and_repository_info(team_to_select)
    team(team_to_select.name).members.map { |committer|
      create_commit_table_row_for_committer_with_repository_info(committer) }
  end

  def create_commit_table_with_committers_and_repository_info
    CSV.generate do |csv|
      csv << ["Committer", "Team", repository_names, "Total"].flatten
      teams.each { |team|
        create_commit_table_rows_with_committers_and_repository_info(team).each { |row| csv << row }
      }
    end
  end

  def create_commit_table_with_weeks_and_team_commits
    CSV.generate do |csv|
      csv <<  ["Week", teams.team_names].flatten
      for_each_week { |week|
        csv << [string_date(week), teams.map { |team| amount_of_commits_for_team_in_week(team.name, week) } ].flatten
      }
    end
  end

  def create_commit_table_with_week_and_repository_info
    CSV.generate do |csv|
      csv <<  ["Week", repository_names].flatten
      for_each_week { |week|
        csv << [string_date(week), @repositories.map { |repository| repository.amount_of_commits_in_week(week) } ].flatten
      }
    end
  end

  def earliest_commit_date
    @commits.earliest_commit_date
  end

  def latest_commit_date
    @commits.latest_commit_date
  end

  def == commit_history
    @commits == commit_history.commits
  end

end
