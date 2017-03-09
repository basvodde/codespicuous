
require 'attempt_to'
class SVNClient

  def repository(repository)
    @repository = repository
  end

  def log_xml(from, to)
    AttemptTo.attempt_to('svn log: "' + @repository + '"', 5) {
      CommandRunner.run("svn log -r{#{from.strftime("%Y-%m-%d")}}:{#{to.strftime("%Y-%m-%d")}} --xml")
    }
  end
end
