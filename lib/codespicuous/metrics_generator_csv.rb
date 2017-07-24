

class MetricsGeneratorCsv

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

end
