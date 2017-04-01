require 'date'

class SVNDataCollector

  attr_accessor :options

  def initialize
    @options = {}

    @svnlogdir = "svnlog"
  end

  def svnlog_file(repository)
      @svnlogdir + "/" + repository.name + ".log"
  end

  def retrieve_svn_log_from(repository)
    if @options["offline"]
      File.read(svnlog_file(repository))
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

  def save_svn_log(repository, xmllog)
    Dir.mkdir(@svnlogdir) unless Dir.exists?(@svnlogdir)
    File.write(svnlog_file(repository), xmllog)
  end

  def collect_commits(repositories, participants, options)
    @options = options
    all_commits = Commits.new
    repositories.each { | repository|
      puts "Getting svn log from repository: " + repository.name
      xmllog = retrieve_svn_log_from(repository)
      save_svn_log(repository, xmllog)
      all_commits += retrieve_commits_from_log(xmllog, repository, participants)
    }
    all_commits
  end

end
