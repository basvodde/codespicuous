
describe "parsing the SVN logs from repositories" do

  subject { SVNLogParser.new }
  context "SVN Log with 2 commits and 3 modified files" do
    svn_log_xml = '<?xml version="1.0" encoding="UTF-8"?>
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
   action="A"
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

    before(:each) do
      @participants = Participants.new(["basvodde", "daniel"])
      subject.xml_to_parse(svn_log_xml)
      subject.participants = @participants
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
      subject.repository = Repository.new("repo", "https://repos.com")
      commit = subject.parse.commits.find_commit("10")
      expect(commit.repository.name).to eq "repo"
    end

    it "knows which files were changed in the commit" do
      commit = subject.parse.commits.find_commit("5")
      expect(commit.changes.size).to eq 2
      expect(commit.changes[0].type).to eq :added
      expect(commit.changes[1].type).to eq :modified
      expect(commit.changes[1].file).to eq "/trunk/implementation.cpp"
    end
  end

  context "Warn for XML elements that aren't implemented yet :)" do

    def log(text)
      '<?xml version="1.0" encoding="UTF-8"?><log>' + text + '</log>'
    end

    def logentry(text)
      log("<logentry>" + text + "</logentry>")
    end

    def paths(text)
      logentry("<paths>" + text + "</paths>")
    end

    it "Warns on non-log entries" do
      expect{subject.parse(log('<notlogentry></notlogentry>'))}.to raise_error("Unexpected log entry: notlogentry")
    end

    it "Warns on unexpected attributes to logentry" do
      expect{subject.parse(log('<logentry shouldntbehere="10"></logentry>'))}.to raise_error("Unexpected attributes log entry: shouldntbehere")
    end

    it "Warns on unexpected elements to logentry" do
      expect{subject.parse(logentry('<huh></huh>'))}.to raise_error("Unexpected element in log entry: huh")
    end

    it "Warns on unexpected elements in path" do
      expect{subject.parse(logentry('<paths><path><uhm></uhm></path></paths>'))}.to raise_error("Unexpected element in path: uhm")
    end

    it "Warns on unexpected attributes in path" do
      expect{subject.parse(logentry('<paths><path bleh="10"></path></paths>'))}.to raise_error("Unexpected attributes in path: bleh")
    end

    it "Warns if attributes in path have unexpected values" do
      expect{subject.parse(paths('<path action="T"></path>'))}.to raise_error("Unexpected value to attribute action in path: T")
      expect{subject.parse(paths('<path action="M" prop-mods="true"></path>'))}.to raise_error("Unexpected value to attribute prop-mods in path: true")
      expect{subject.parse(paths('<path action="M" prop-mods="false" text-mods="false"></path>'))}.to raise_error("Unexpected value to attribute text-mods in path: false")
      expect{subject.parse(paths('<path action="M" prop-mods="false" text-mods="true" kind="space"></path>'))}.to raise_error("Unexpected value to attribute kind in path: space")
    end
  end
end
