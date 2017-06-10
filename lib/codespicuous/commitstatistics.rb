require 'date'
require 'csv'

class CommitStatisticsForCommitterInRepository
  attr_writer :commits

  def initialize
    self.commits = {}
  end

  def commit(date, amount)
    @commits[DateTime.parse(date.to_s)] ||= 0
    @commits[DateTime.parse(date.to_s)] += amount.to_i
  end

  def amount_of_commits
    @commits.values.inject(0) { |sum, commits_of_week| sum += commits_of_week }
  end

  def amount_of_weeks_committed
    @commits.size
  end

  def amount_of_commits_in_week week_start
    @commits[week_start] ? @commits[week_start] : 0
  end

  def first_week_committed
    commit_week = DateTime.now
    @commits.each_key { |date|
      commit_week = date if date < commit_week
    }
    commit_week
  end

  def last_week_committed
    commit_week = DateTime.new(1977)
    @commits.each_key { |date|
      commit_week = date if date > commit_week
    }
    commit_week
  end
end

class CommitStatisticsForCommitter

  attr_accessor :username, :team, :commits_in_repositories

  def initialize(username)
    self.username = username
    self.commits_in_repositories = {}
  end

  def commit(repository, date, amount)
    repository(repository.name).commit(date, amount)
  end

  def repository name
    @commits_in_repositories[name] ||= CommitStatisticsForCommitterInRepository.new
  end

  def repositories_committed_to
    @commits_in_repositories.keys
  end

  def amount_of_commits
    @commits_in_repositories.values.inject(0) { |sum, repository|
      sum + repository.amount_of_commits
    }
  end

  def amount_of_weeks_committed_to_repository name
    repository(name).amount_of_weeks_committed
  end

  def amount_of_comnmits_to_repository name
    repository(name).amount_of_commits
  end

  def amount_of_commits_in_week week_start
    @commits_in_repositories.each_value.inject(0) { |sum, commits|
      sum + commits.amount_of_commits_in_week(week_start)
    }
  end

  def amount_of_commits_to_repository_in_week(name, week_start)
    repository(name).amount_of_commits_in_week(week_start)
  end

  def first_week_committed
    commit_week = DateTime.now
    @commits_in_repositories.each_value { |commits|
      commit_week = commits.first_week_committed if commits.first_week_committed < commit_week
    }
    commit_week
  end

  def last_week_committed
    commit_week = DateTime.new(1977)
    @commits_in_repositories.each_value { |commits|
      commit_week = commits.last_week_committed if commits.last_week_committed > commit_week
    }
    commit_week
  end
end

class CommitStatistics

  attr_accessor :committer_statistics

  def initialize
    self.committer_statistics = {}
  end

  def commits= commits
    commits.each { |commit|
      commit(commit.author, commit.repository, commit.date)
    }
  end

  def teams= teams
    teams.each_member { |team, member|
      committer(member.username).team = team.name
    }
  end

  def commit(username, repository, date)
    committer(username).commit(repository, date, 1)
  end

  def committer username
    @committer_statistics[username] ||= CommitStatisticsForCommitter.new(username)
  end

  def committer_in_team(team)
    team_members = []
    @committer_statistics.each_value { |committer|
      team_members << committer.username if committer.team == team || team == nil
    }
    team_members
  end

  def repositories_committed_to
    names = []
    @committer_statistics.each_value { |stats_for_committer|
      names << stats_for_committer.repositories_committed_to
    }
    names.flatten.uniq
  end

  def teams
    teams = []
    @committer_statistics.each_value { |stats_for_committer|
      teams << stats_for_committer.team
    }
    teams.flatten.uniq.sort
  end

  def first_week_committed
    commit_week = DateTime.now
    @committer_statistics.each_value { |committer|
      commit_week = committer.first_week_committed if committer.first_week_committed < commit_week
    }
    commit_week
  end

  def last_week_committed
    commit_week = DateTime.new(1977)
    @committer_statistics.each_value { |committer|
      commit_week = committer.last_week_committed if committer.last_week_committed > commit_week
    }
    commit_week
  end

  def amount_of_comitters
    self.committer_statistics.size
  end

  def amount_of_commits_for_team_in_week(team, week)
    @committer_statistics.each_value.inject(0) { |amount_of_commits, committer|
      amount_of_commits + ((committer.team == team) ? committer.amount_of_commits_in_week(week) : 0)
    }
  end

  def amount_of_commits_to_repository_in_week(repository, week)
    @committer_statistics.each_value.inject(0) { |amount_of_commits, committer|
      amount_of_commits + committer.amount_of_commits_to_repository_in_week(repository, week)
    }
  end

  def for_each_week
    (first_week_committed..last_week_committed).step(7) { |week|
      yield week
    }
  end

  def string_date(date)
    date.strftime("%Y-%m-%d")
  end

  def create_commit_table_row_for_committer_with_repository_info committer
    [committer.username, committer.team, repositories_committed_to.map { |repository| committer.amount_of_comnmits_to_repository(repository)}, committer.amount_of_commits].flatten
  end

  def create_commit_table_rows_with_committers_and_repository_info(team_to_select)
    @committer_statistics.values.select { |committer| committer.team == team_to_select }.map { |committer| create_commit_table_row_for_committer_with_repository_info(committer) }
  end

  def create_commit_table_with_committers_and_repository_info
    CSV.generate do |csv|
      csv << ["Committer", "Team", repositories_committed_to, "Total"].flatten
      teams.each { |team|
        create_commit_table_rows_with_committers_and_repository_info(team).each { |row| csv << row }
      }
    end
  end

  def create_commit_table_with_weeks_and_team_commits
    CSV.generate do |csv|
      csv <<  ["Week", teams].flatten
      for_each_week { |week|
        csv << [string_date(week), teams.map { |team| amount_of_commits_for_team_in_week(team, week) } ].flatten
      }
    end
  end

  def create_commit_table_with_week_and_repository_info
    CSV.generate do |csv|
      csv <<  ["Week", repositories_committed_to].flatten
      for_each_week { |week|
        csv << [string_date(week), repositories_committed_to.map { |repository| amount_of_commits_to_repository_in_week(repository, week) } ].flatten
      }
    end
  end

  def create_commit_table_with_weeks_and_committers(team=nil)
    CSV.generate do |csv|
      csv <<  ["Week", committer_in_team(team) ].flatten
      for_each_week { |week|
        csv <<  [string_date(week), @committer_statistics.values.select { |committer| committer.team == team || team == nil }.map { |committer| committer.amount_of_commits_in_week(week)} ].flatten
        }
    end
  end
end

