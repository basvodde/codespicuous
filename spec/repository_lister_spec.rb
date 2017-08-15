
describe "listing which repositories the team committed to" do

  subject { RepositoryLister.new }

  it "informs that the team didn't commit to any of the repositories" do

    expect(subject).to receive(:puts).with("No teams committed in any of the repositories")
    subject.list(CommitHistory.new)
  end

  it "informs that one team has committed in one repository" do
    commit_history = CommitHistoryBuilder.new.
      in_repository("repo").
        commits_of("basvodde").of_team("Wine").
        at("2016-04-18").times(2).
     build

    expect(subject).to receive(:puts).with("Team \"Wine\" committed in:\n  repo\n")
    subject.list(commit_history)
  end

end
