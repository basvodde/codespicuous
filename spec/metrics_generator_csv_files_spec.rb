
describe "Generate csv metric files" do

  before (:each) do
    @commit_history = CommitHistory.new
    @generator =  MetricsGeneratorCsvFiles.new(CodespicuousConfig.new, @commit_history)
  end

  it "generates different type of csv file metrics" do

    expect(@generator).to receive(:create_csv_files_output_directory)
    expect(@generator).to receive(:create_commit_table_with_week_and_repository_info)
    expect(@generator).to receive(:create_commit_table_with_weeks_and_team_commits)
    expect(@generator).to receive(:create_commit_table_with_committers_and_repository_info)
    expect(@generator).to receive(:create_commit_table_with_weeks_and_committers)

    @generator.generate
  end

  it "Should create an output directory when it doesn't exists" do
    expect(Dir).to receive(:exists?).with("csv_files").and_return(false)
    expect(Dir).to receive(:mkdir).with("csv_files")
    @generator.create_csv_files_output_directory
  end

  it "Should not create an output directory when it does exists" do
    expect(Dir).to receive(:exists?).with("csv_files").and_return(true)
    expect(Dir).not_to receive(:mkdir).with("csv_files")
    @generator.create_csv_files_output_directory
  end

  it "can generate the week and repository files" do
    expect(@generator.all_csv_generator).to receive(:create_commit_table_with_week_and_repository_info).and_return("all_csv_data")
    expect(@generator.teams_csv_generator).to receive(:create_commit_table_with_week_and_repository_info).and_return("teams_csv_data")
    expect(File).to receive(:write).with("csv_files/all_week_and_repository_info.csv", "all_csv_data")
    expect(File).to receive(:write).with("csv_files/teams_week_and_repository_info.csv", "teams_csv_data")

    @generator.create_commit_table_with_week_and_repository_info
  end

  it "can generate the week and team commit files" do
    expect(@generator.teams_csv_generator).to receive(:create_commit_table_with_weeks_and_team_commits).and_return("csv_data")
    expect(File).to receive(:write).with("csv_files/teams_week_and_team_commits.csv", "csv_data")

    @generator.create_commit_table_with_weeks_and_team_commits
  end

  it "can generate the commit and repository info files" do
    expect(@generator.teams_csv_generator).to receive(:create_commit_table_with_committers_and_repository_info).and_return("csv_data")
    expect(File).to receive(:write).with("csv_files/teams_committer_and_repository_info.csv", "csv_data")

    @generator.create_commit_table_with_committers_and_repository_info
  end

  it "can generate the weeks and committers info files" do
    expect(@generator.all_csv_generator).to receive(:create_commit_table_with_weeks_and_committers).and_return("csv_data")
    expect(File).to receive(:write).with("csv_files/teams_weeks_and_committers_info.csv", "csv_data")

    @generator.create_commit_table_with_weeks_and_committers
  end

  it "can generate the weeks and committers per team info files" do
    team = Team.new("teamx")
    teams = Teams.new
    teams.add(team)
    @commit_history.configure(teams, @commit_history.repositories)
    @generator =  MetricsGeneratorCsvFiles.new(CodespicuousConfig.new, @commit_history)

    expect(@generator.all_csv_generator).to receive(:create_commit_table_with_weeks_and_committers).and_return("csv_data")
    expect(@generator.all_csv_generator).to receive(:create_commit_table_with_weeks_and_committers).with("teamx").and_return("csv_data2")
    expect(File).to receive(:write).with("csv_files/teams_weeks_and_committers_info.csv", "csv_data")
    expect(File).to receive(:write).with("csv_files/teams_weeks_and_committers_info_teamx.csv", "csv_data2")

    @generator.create_commit_table_with_weeks_and_committers
  end

end
