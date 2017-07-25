
require 'codespicuous.rb'

describe "The repositories that we are examining" do

  it "can comparing two repositories and they are the same" do
    repo1 = Repository.new("repo", "url")
    repo2 = Repository.new("repo", "url")

    expect(repo1).to eq(repo2)
  end

  it "can comparing two repositories that aren't the same" do
    repo1 = Repository.new("repo1", "url")
    repo2 = Repository.new("repo2", "url")

    expect(repo1).not_to eq(repo2)
  end

  it "can comparing two repositories of which one has commits will throw an exception" do
    repo1 = Repository.new("repo1", "url")
    repo2 = Repository.new("repo1", "url")

    repo1.add_commit(Commit.new)

    expect{repo1 == repo2}.to raise_error(SameRepositoriesWithDifferentCommitsError)
  end
end

