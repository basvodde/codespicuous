
require 'codespicuous.rb'

describe "commits" do

  it "be able to plus to Commits" do
    commit1 = Commit.new
    commits1 = Commits.new
    commits1.add(commit1)

    commit2 = Commit.new
    commits2 = Commits.new
    commits2.add(commit2)

    result = Commits.new
    result.add(commit1)
    result.add(commit2)

    expect(commits1 + commits2).to eq result
  end

  it "can compare Commits and they are equal" do
    commit1 = Commit.new
    commits1 = Commits.new
    commits2 = Commits.new
    commits1.add(commit1)
    commits2.add(commit1)

    expect(commits1).to eq(commits2)
  end

  it "can compare Commits and they are equal with different objects" do
    commit1 = Commit.new
    commit2 = Commit.new

    commit1.repository = Repository.new("repo", "url")
    commit2.repository = Repository.new("repo", "url")
    commit1.revision = 1
    commit2.revision = 2

    commits1 = Commits.new
    commits2 = Commits.new

    commits1.add(commit1)
    commits2.add(commit1)

    expect(commits1).to eq(commits2)
  end


  it "can compare Commits and they aren't equal" do
    commit1 = Commit.new
    commits1 = Commits.new
    commits2 = Commits.new
    commits1.add(commit1)

    expect(commits1).not_to eq(commits2)
  end

  it "can inspect commits without printing the entire data structure recursively" do
    commit = Commit.new
    commit.repository = Repository.new("Repo", "url")
    commit.revision = 10
    expect(commit).to receive(:my_object_id).and_return(1)

    expect(commit.inspect).to eq("Commit(o:1) Repo:10")
  end

  it "two commits are the same when they are in the same repository and have the same revision" do
    commit1 = Commit.new
    commit2 = Commit.new
    commit1.repository = Repository.new("Repos", "url")
    commit2.repository = Repository.new("Repos", "url")
    commit1.revision = 20
    commit2.revision = 20

    expect(commit1).to eq(commit2)
  end

  it "can compare commits, but raises an exception when some of the others are not the same" do
    commit1 = Commit.new
    commit2 = Commit.new
    commit1.repository = Repository.new("Repos", "url")
    commit2.repository = Repository.new("Repos", "url")
    commit1.revision = 20
    commit2.revision = 20

    commit1.author = "me"

    expect{commit1 == commit2}.to raise_error(CommitSameButDifferentError)
  end

end
