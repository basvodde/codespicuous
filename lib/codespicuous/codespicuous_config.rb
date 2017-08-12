
require 'pathname'

class CodespicuousConfig

  attr_accessor :offline, :configuration_file_name, :list_repositories

  def initialize
    @offline = false
    @configuration_file_name = "codespicuous.yaml"
    @input_path = Pathname.new(".")
    @list_repositories = false
  end

  def path_to_configuration_file
    (@input_path + @configuration_file_name).to_s
  end
end
