
require 'codespicuous.rb'

describe "The repositories that we are examining" do

  repositories_in_csv = "name,url
kewl,https://github/kewl
also-ok,https://github/also-ok
"
  subject { Repositories.new }

  before (:each) do
    parser = RepositoriesParserFromCsv.new.parse(repositories_in_csv)
    @repositories = parser.repositories
  end

  it "reads the repositories from a CSV" do
    expect(@repositories.amount).to eq 2
  end

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

