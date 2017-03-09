require 'date'

class SVNDataCollector


  def retrieve_svn_log_from(repository)
    svn = SVNClient.new
    svn.repository(repository.url)
    now = DateTime.now
    svn.log_xml(now.prev_year, now)
  end

  def retrieve_commits_from_log(xmllog, repository)
    parser = SVNLogParser.new
    parser.repository = repository
    parser.parse(xmllog)
    parser.commits
  end

  def collect_commits(repositories)
    all_commits = Commits.new
    repositories.each { | repository|
      xmllog = retrieve_svn_log_from(repository)
      all_commits += retrieve_commits_from_log(xmllog, repository)
    }
    all_commits
  end

end
