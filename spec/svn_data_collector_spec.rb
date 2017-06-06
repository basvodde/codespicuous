
describe "Collecting data from SVN" do

  subject { SVNDataCollector.new }

  before (:each) do
    @heh_repository = Repository.new("heh", "https://heh")
    @xmllog = double(:xmllog)
  end

  it "should get the xml log from the svn client" do
    svnclient = double(:svnclient)

    expect(SVNClient).to receive(:new).and_return(svnclient)
    expect(DateTime).to receive(:now).and_return(DateTime.new(2001))

    expect(svnclient).to receive(:repository).with(@heh_repository.url)
    expect(svnclient).to receive(:log_xml).with(DateTime.new(2000), DateTime.new(2001)).and_return(@xmllog)

    expect(subject.retrieve_svn_log_from(@heh_repository)).to eq @xmllog
  end

  it "should get the xml log from file when offline" do
    subject.options["offline"] = true
    expect(File).to receive(:read).with("svnlog/heh.log").and_return(@xmllog)
    expect(subject.retrieve_svn_log_from(@heh_repository)).to eq @xmllog
  end

  it "should parse the xml log that was retrieved from the svn client" do

    svnxmlparser = double(:parser)
    commits = Commits.new

    expect(SVNLogParser).to receive(:new).and_return(svnxmlparser)
    expect(svnxmlparser).to receive(:parse).with(@xmllog)
    expect(svnxmlparser).to receive(:commits).and_return(commits)

    expect(subject.retrieve_commits_from_log(@xmllog)).to eq commits
  end

  it "Should collect the log for one repository" do

    commit = Commit.new
    commits = Commits.new
    commits.add(commit)

    expect(subject).to receive(:puts).with("Getting svn log from repository: heh")
    expect(subject).to receive(:retrieve_svn_log_from).with(@heh_repository).and_return(@xmllog)
    expect(subject).to receive(:save_svn_log).with(@heh_repository, @xmllog)
    expect(subject).to receive(:retrieve_commits_from_log).with(@xmllog).and_return(commits)

    expect(subject.collect_commits_for_repository(@heh_repository)).to eq (commits)
    expect(commit.repository).to eq @heh_repository
  end

  def create_commits_with_one_commit_in_repository repository
    commit = Commit.new
    commit.repository = repository
    commits = Commits.new
    commits.add(commit)
    commits
  end

  it "Should collect the log for each repository and add the commits" do
    repositories  = Repositories.new
    wow_repository = Repository.new("wow", "https://wow")
    repositories.add(@heh_repository)
    repositories.add(wow_repository)

    heh_commits = create_commits_with_one_commit_in_repository(@heh_repository)
    wow_commits = create_commits_with_one_commit_in_repository(wow_repository)

    expect(subject).to receive(:collect_commits_for_repository).with(@heh_repository).and_return(heh_commits)
    expect(subject).to receive(:collect_commits_for_repository).with(wow_repository).and_return(wow_commits)

    expect(subject.collect_commit_history(repositories)).to eq (CommitHistory.new(heh_commits + wow_commits))
  end

  it "Should write the svn logs to the svnlog directory" do
    expect(Dir).to receive(:exists?).with("svnlog").and_return(true)
    expect(File).to receive(:write).with("svnlog/heh.log", "xmllog")

    subject.save_svn_log(@heh_repository, "xmllog")
  end

  it "Should write the svn logs to the svnlog directory which must be created first" do
    expect(Dir).to receive(:exists?).with("svnlog").and_return(false)
    expect(Dir).to receive(:mkdir).with("svnlog")
    expect(File).to receive(:write)

    subject.save_svn_log(@heh_repository, "xmllog")
  end
end
