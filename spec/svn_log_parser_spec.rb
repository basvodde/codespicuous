
describe "parsing the SVN logs from repositories" do

  csv_log_xml = '<?xml version="1.0" encoding="UTF-8"?>
<log>
<logentry
   revision="10">
<author>basvodde</author>
<date>2016-01-04T01:59:13</date>
<paths>
<path
   action="M"
   prop-mods="false"
   text-mods="true"
   kind="file">/trunk/header.hpp</path>
</paths>
<msg>Summary:optimize implementation.</msg>
</logentry>
<logentry
   revision="5">
<author>daniel</author>
<date>2016-01-04T04:37:03.111034Z</date>
<paths>
<path
   text-mods="true"
   kind="file"
   action="M"
   prop-mods="false">/trunk/otherheader.hpp</path>
<path
   text-mods="true"
   kind="file"
   action="M"
   prop-mods="false">/trunk/implementation.cpp</path>
</paths>
<msg>Exciting message </msg>
</logentry>
</log>'

  subject { SVNLogParser.new }

  before(:each) do
    @participants = Participants.new(["basvodde", "daniel"])
    subject.xml_to_parse(csv_log_xml)
    subject.participants = @participants
    subject.repository = Repository.new("repo")
  end

  it "parses SVN log files" do
    subject.participants = Participants.new("basvodde")
    subject.parse
    commits = subject.commits
    expect(commits.amount).to eq 1
  end

  it "knows Bas had one commit" do
    subject.parse
    expect(@participants.find_by_loginname("basvodde").commits.amount).to eq 1
  end

  it "knows all the details of the commit" do
    subject.parse
    commit = subject.commits.find_commit("10")
    expect(commit.message).to eq "Summary:optimize implementation."
    expect(commit.author).to eq "basvodde"
    expect(commit.participant.loginname).to eq "basvodde"
    expect(commit.date).to eq DateTime.new(2016,1,4,1,59,13)
  end

  it "adds the repository information to each commit" do
    commit = subject.parse.commits.find_commit("10")
    expect(commit.repository.name).to eq "repo"
  end

  it "knows which files were changed in the commit" do
    commit = subject.parse.commits.find_commit("10")
    expect(commit.changes.size).to eq 1
    expect(commit.changes[0].type).to eq :modified
    expect(commit.changes[0].file).to eq "/trunk/header.hpp"
  end
end
