
require 'pathname'

class CodespicuousConfig

  attr_accessor :offline, :configuration_file_name, :list_repositories, :input_path, :output_path

  def initialize
    @offline = false
    @configuration_file_name = "codespicuous.yaml"
    @input_path = Pathname.new(".")
    @output_path = Pathname.new(".")
    @list_repositories = false
    @svnlogdir = "svnlog"

    @output_dir_csv_files = "csv_files"
  end

  def input_path=(path)
    @input_path = Pathname.new(path)
  end

  def output_path=(path)
    @output_path = Pathname.new(path)
  end

  def path_to_configuration_file
    (@input_path + @configuration_file_name).to_s
  end

  def path_to_cached_svn_log(repository_name)
    (Pathname.new(path_to_cached_svn_log_dir) + Pathname.new(repository_name + ".log")).to_s
  end

  def path_to_cached_svn_log_dir
    (@input_path + Pathname.new(@svnlogdir)).to_s
  end

  def path_to_output_dir_for_csv_files
    (@output_path + Pathname.new(@output_dir_csv_files)).to_s
  end
end
