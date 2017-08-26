require 'date'

class SVNDataCollector

  attr_reader :config

  def initialize(config, commit_history = CommitHistory.new)
    @commit_history = commit_history
    @config = config
  end

  def retrieve_svn_log_from(repository)
    if config.offline
      File.read(config.path_to_cached_svn_log(repository.name))
    else
      svn = SVNClient.new
      svn.repository(repository.url)
      svn.log_xml
    end
  end

  def retrieve_commits_from_log(xmllog)
    parser = SVNLogParser.new
    parser.parse(xmllog)
    parser.commits
  end

  def save_svn_log(repository, xmllog)
    Dir.mkdir(config.path_to_cached_svn_log_dir) unless Dir.exists?(config.path_to_cached_svn_log_dir)
    File.write(config.path_to_cached_svn_log(repository.name), xmllog)
  end

  def collect_commits_for_repository(repository)
      puts "Getting svn log from repository: " + repository.name
      xmllog = retrieve_svn_log_from(repository)
      save_svn_log(repository, xmllog)
      commits_in_repository = retrieve_commits_from_log(xmllog)
      commits_in_repository.set_repository(repository)
      commits_in_repository
  end

  def collect_commit_history(repositories)
    repositories.each { | repository|
      @commit_history.add_commits(collect_commits_for_repository(repository))
    }
    @commit_history
  end

end
