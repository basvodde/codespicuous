
describe "Collecting data from SVN" do

  subject { SVNDataCollector.new }

  before (:each) do

    @heh_repository = Repository.new("heh", "https://heh")
    @participants = Participants.new(["basvodde", "daniel"])
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
    expect(File).to receive(:read).with("heh.log").and_return(@xmllog)
    expect(subject.retrieve_svn_log_from(@heh_repository)).to eq @xmllog
  end

  it "should parse the xml log that was retrieved from the svn client" do

    svnxmlparser = double(:parser)

    commits = Commits.new

    expect(SVNLogParser).to receive(:new).and_return(svnxmlparser)

    expect(svnxmlparser).to receive(:repository=).with(@heh_repository)
    expect(svnxmlparser).to receive(:participants=).with(@participants)
    expect(svnxmlparser).to receive(:parse).with(@xmllog)
    expect(svnxmlparser).to receive(:commits).and_return(commits)

    expect(subject.retrieve_commits_from_log(@xmllog, @heh_repository, @participants)).to eq commits
  end

  def create_commits_with_one_commit_in_repository repository
    commit = Commit.new
    commit.repository = repository
    commits = Commits.new
    commits.add(commit)
    commits
  end

  it "Should collect the log for each repository and add the commits" do
    options = { "option" => true }
    repositories  = Repositories.new
    wow_repository = Repository.new("wow", "https://wow")
    repositories.add(@heh_repository)
    repositories.add(wow_repository)

    heh_commits = create_commits_with_one_commit_in_repository(@heh_repository)
    wow_commits = create_commits_with_one_commit_in_repository(wow_repository)

    expect(subject).to receive(:puts).with("Getting svn log from repository: heh")
    expect(subject).to receive(:retrieve_svn_log_from).with(@heh_repository).and_return(@xmllog)
    expect(subject).to receive(:retrieve_commits_from_log).with(@xmllog, @heh_repository, @participants).and_return(heh_commits)
    expect(subject).to receive(:puts).with("Getting svn log from repository: wow")
    expect(subject).to receive(:retrieve_svn_log_from).with(wow_repository).and_return(@xmllog)
    expect(subject).to receive(:retrieve_commits_from_log).with(@xmllog, wow_repository, @participants).and_return(wow_commits)

    expect(subject.collect_commits(repositories, @participants, options)).to eq (heh_commits + wow_commits)
    expect(subject.options).to eq options
  end
end
