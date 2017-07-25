

class MetricsGeneratorCsv

  include DateUtil

  def initialize(commit_history)
    @commit_history = commit_history
  end

  def generate

  end

  def create_commit_table_row_for_committer_with_repository_info committer
    [committer.username, committer.team.name, @commit_history.repository_names.map { |repository|
      committer.amount_of_commits_to_repository(repository)}, committer.amount_of_commits].flatten
  end

  def create_commit_table_rows_with_committers_and_repository_info(team_to_select)
    @commit_history.team(team_to_select.name).members.map { |committer|
      create_commit_table_row_for_committer_with_repository_info(committer) }
  end

  def create_commit_table_with_committers_and_repository_info
    CSV.generate do |csv|
      csv << ["Committer", "Team", @commit_history.repository_names, "Total"].flatten
      @commit_history.teams.each { |team|
        create_commit_table_rows_with_committers_and_repository_info(team).each { |row| csv << row }
      }
    end
  end

  def create_commit_table_with_weeks_and_team_commits
    CSV.generate do |csv|
      csv <<  ["Week", @commit_history.teams.team_names].flatten
      for_each_week(@commit_history.earliest_commit_date, @commit_history.latest_commit_date) { |week|
        csv << [string_date(week), @commit_history.teams.map { |team|
          @commit_history.amount_of_commits_for_team_in_week(team.name, week)
        } ].flatten
      }
    end
  end

  def create_commit_table_with_week_and_repository_info
    CSV.generate do |csv|
      csv <<  ["Week", @commit_history.repository_names].flatten
      for_each_week(@commit_history.earliest_commit_date, @commit_history.latest_commit_date) { |week|
        csv << [string_date(week), @commit_history.repositories.map { |repository|
          repository.amount_of_commits_in_week(week)
        } ].flatten
      }
    end
  end

  def create_commit_table_with_weeks_and_committers(team=nil)
    CSV.generate do |csv|
      csv <<  ["Week", @commit_history.teams.member_usernames(team) ].flatten
      for_each_week(@commit_history.earliest_commit_date, @commit_history.latest_commit_date) { |week|
        csv <<  [string_date(week), @commit_history.teams.member_usernames(team).map { |name|
          @commit_history.committers.find_by_username(name).amount_of_commits_in_week(week)
        }].flatten
      }
    end
  end

end
