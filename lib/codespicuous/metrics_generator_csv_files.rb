
class MetricsGeneratorCsvFiles

  def create_csv_files_output_directory
    Dir.mkdir(@config.path_to_output_dir_for_csv_files) unless Dir.exists?(@config.path_to_output_dir_for_csv_files)
  end

  def initialize(config, commit_history)
    @config = config
  end

  def generate
    create_csv_files_output_directory
    create_commit_table_with_week_and_repository_info
  end
end
