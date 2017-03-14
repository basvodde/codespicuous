require 'date'

class SVNDataCollector

  attr_accessor :options

  def initialize
    @options = {}
  end

  def retrieve_svn_log_from(repository)
    if @options["offline"]
      File.read(repository.name + ".log")
    else
      svn = SVNClient.new
      svn.repository(repository.url)
      now = DateTime.now
      svn.log_xml(now.prev_year, now)
    end
  end

  def retrieve_commits_from_log(xmllog, repository, participants)
    parser = SVNLogParser.new
    parser.repository = repository
    parser.participants = participants
    parser.parse(xmllog)
    parser.commits
  end

  def collect_commits(repositories, participants, options)
    @options = options
    all_commits = Commits.new
    repositories.each { | repository|
      xmllog = retrieve_svn_log_from(repository)
      all_commits += retrieve_commits_from_log(xmllog, repository, participants)
    }
    all_commits
  end

end
