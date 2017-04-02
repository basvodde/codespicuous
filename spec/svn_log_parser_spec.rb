
describe "parsing the SVN logs from repositories" do

  def log(text)
    '<?xml version="1.0" encoding="UTF-8"?><log>' + text + '</log>'
  end

  def logentry(revision, author, date, message, additional_tags, paths)
    "<logentry revision=\"#{revision}\"><author>#{author}</author><date>#{date}</date>#{additional_tags} <paths>" + paths + "</paths><msg>#{message}</msg></logentry>"
  end

  def path(action, propmods, textmods, kind, file)
    "<path action=\"#{action}\" prop-mods=\"#{propmods}\" text-mods=\"#{textmods}\" kind=\"#{kind}\">#{file}</path>"
  end

  def log_with_default_logentry(additional_tags, paths)
    log(logentry(1, "someone", "2017-01-01", "message", additional_tags, paths))
  end

  def log_with_paths(paths)
    log_with_default_logentry("", paths)
  end

  subject { SVNLogParser.new }

  context "SVN Log with 2 commits and 3 modified files" do
    before(:each) do

      svn_log_xml = log(
        logentry(10, "basvodde", "2016-01-04T01:59:13", "Summary:optimize implementation.", "",
                 path("M", true, true, "file", "/trunk/header.hpp")) +
        logentry(5, "daniel", "2016-01-04T04:37:03.111034Z", "Exciting message", "",
                 path("A", false, true, "file", "/trunk/otherheader.hpp") +
                 path("M", false, true, "file", "/trunk/implementation.cpp")))

      subject.xml_to_parse(svn_log_xml)
    end

    it "parses SVN log files" do
      subject.parse
      commits = subject.commits
      expect(commits.amount).to eq 2
    end

    it "knows Bas had one commit" do
      subject.parse
      expect(subject.commits.find_by_committer("basvodde").amount).to eq 1
    end

    it "knows Bas modified properties" do
      subject.parse
      expect(subject.commits.find_commit("10").changes[0].changed_property?).to be true
    end

    it "knows all the details of the commit" do
      subject.parse
      commit = subject.commits.find_commit("10")
      expect(commit.message).to eq "Summary:optimize implementation."
      expect(commit.author).to eq "basvodde"
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

    it "Warns on non-log entries" do
      expect{subject.parse(log('<notlogentry></notlogentry>'))}.to raise_error("Unexpected log entry: notlogentry")
    end

    it "Warns on unexpected attributes to logentry" do
      expect{subject.parse(log('<logentry shouldntbehere="10"></logentry>'))}.to raise_error("Unexpected attributes log entry: shouldntbehere")
    end

    it "Warns on unexpected elements to logentry" do
      expect{subject.parse(log_with_default_logentry('<huh></huh>', ""))}.to raise_error("Unexpected element in log entry: huh")
    end

    it "Warns on unexpected elements in path" do
      expect{subject.parse(log_with_default_logentry("", '<path><uhm></uhm></path>'))}.to raise_error("Unexpected element in path: uhm")
    end

    it "Warns on unexpected attributes in path" do
      expect{subject.parse(log_with_default_logentry("", '<path bleh="10"></path>'))}.to raise_error("Unexpected attributes in path: bleh")
    end

    it "Warns if attributes in path have unexpected values" do
      expect{subject.parse(log_with_paths('<path action="T"></path>'))}.to raise_error("Unexpected value to attribute action in path: T")
      expect{subject.parse(log_with_paths('<path action="M" prop-mods="false" text-mods="true" kind="space"></path>'))}.to raise_error("Unexpected value to attribute kind in path: space")
    end

    it "Warns by printing output on strange text-mods value. Needs to be checked what to do with it." do
      expect(subject).to receive(:puts).with('Unexpected value to attribute text-mods in path: false')
      subject.parse(log_with_paths('<path action="M" prop-mods="false" text-mods="false" kind="file"></path>'))
    end
  end

  context "Less common svn log elements" do

    it "Can deal with copyfrom-path" do
      xmllog = log_with_paths('<path action="A" prop-mods="false" text-mods="true" kind="file" copyfrom-path="originalfile.cpp" copyfrom-rev="18">newfile</path>')
      subject.parse(xmllog)
      expect(subject.commits[0].changes[0].copyfrom).to eq "originalfile.cpp"
      expect(subject.commits[0].changes[0].copyrev).to eq "18"
    end

    it "Can deal with deleted files" do
      xmllog = log_with_paths(path("D", false, true, "file", "/trunk/header.hpp"))
      subject.parse(xmllog)
      expect(subject.commits[0].changes[0].type).to eq :deleted
    end

    it "Can deal with renames files" do
      xmllog = log_with_paths(path("R", false, false, "file", "/trunk/header.hpp"))
      subject.parse(xmllog)
      expect(subject.commits[0].changes[0].type).to eq :renamed
    end

    it "text-mods can be false when the file is deleted" do
      xmllog = log_with_paths(path("D", false, false, "file", "/trunk/header.hpp"))
      subject.parse(xmllog)

      # No exception
    end

    it "can add directories" do
      xmllog = log_with_paths(path("A", false, false, "dir", "/trunk"))
      subject.parse(xmllog)
      expect(subject.commits[0].changes[0].kind).to eq :dir
    end

  end

end
