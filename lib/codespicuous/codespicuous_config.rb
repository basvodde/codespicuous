
require 'pathname'

class CodespicuousConfig

  attr_accessor :offline, :configuration_file_name, :list_repositories, :input_path, :output_path

  def initialize
    @offline = false
    @configuration_file_name = "codespicuous.yaml"
    @input_path = Pathname.new(".")
    @list_repositories = false
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
end
