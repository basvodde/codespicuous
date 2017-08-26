
require 'attempt_to'
class SVNClient

  def repository(repository)
    @repository = repository
  end

  def log_xml
    AttemptTo.attempt_to('svn log: "' + @repository + '"', 5) {
      CommandRunner.run("svn log #{@repository} --xml --non-interactive ")
    }
  end


  def log_xml_for_timeframe(from, to)
    AttemptTo.attempt_to('svn log: "' + @repository + '"', 5) {
      CommandRunner.run("svn log #{@repository} -r{#{from.strftime("%Y-%m-%d")}}:{#{to.strftime("%Y-%m-%d")}} --xml --non-interactive ")
    }
  end
end
