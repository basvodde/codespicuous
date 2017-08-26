
class MetricsGeneratorCsvFiles

  attr_reader :all_csv_generator, :teams_csv_generator

  def create_csv_files_output_directory
    Dir.mkdir(@config.path_to_output_dir_for_csv_files) unless Dir.exists?(@config.path_to_output_dir_for_csv_files)
  end

  def initialize(config, commit_history)
    @config = config
    @all_csv_generator = MetricsGeneratorCsv.new(commit_history)
    @restricted_history =  commit_history.restrict_to_teams
    @teams_csv_generator = MetricsGeneratorCsv.new(@restricted_history)
  end

  def generate
    create_csv_files_output_directory
    create_commit_table_with_week_and_repository_info
    create_commit_table_with_weeks_and_team_commits
    create_commit_table_with_committers_and_repository_info
    create_commit_table_with_weeks_and_committers
  end

  def create_commit_table_with_week_and_repository_info
    File.write(@config.path_to_csv_file("all_week_and_repository_info.csv"), @all_csv_generator.create_commit_table_with_week_and_repository_info)
    File.write(@config.path_to_csv_file("teams_week_and_repository_info.csv"), @teams_csv_generator.create_commit_table_with_week_and_repository_info)
  end

  def create_commit_table_with_weeks_and_team_commits
    File.write(@config.path_to_csv_file("teams_week_and_team_commits.csv"), @teams_csv_generator.create_commit_table_with_weeks_and_team_commits)
  end

  def create_commit_table_with_committers_and_repository_info
    File.write(@config.path_to_csv_file("teams_committer_and_repository_info.csv"), @teams_csv_generator.create_commit_table_with_committers_and_repository_info)
  end

  def create_commit_table_with_weeks_and_committers
    File.write(@config.path_to_csv_file("teams_weeks_and_committers_info.csv"), @all_csv_generator.create_commit_table_with_weeks_and_committers)
    @restricted_history.teams.each do | team |
      File.write(@config.path_to_csv_file("teams_weeks_and_committers_info_#{team.name}.csv"), @all_csv_generator.create_commit_table_with_weeks_and_committers(team.name))
    end

  end
end
