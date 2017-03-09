
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

  it "can compare Commits" do

    commit1 = Commit.new
    commits1 = Commits.new
    commits2 = Commits.new
    commits1.add(commit1)
    commits2.add(commit1)

    expect(commits1).to eq(commits2)
  end

end
