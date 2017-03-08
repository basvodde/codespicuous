
require 'rexml/document'

class CSVLogParser

  attr_accessor :participants, :repository

  def initialize
    @commits = Commits.new
  end

  def xml_to_parse(xml_string)
    @xml_to_parse = xml_string
  end

  def parse
    xml = REXML::Document.new(@xml_to_parse)
    xml.elements.each( "*/logentry" ) do |logentry|
      commit = create_commit_from_log_entry(logentry, @repository)
      @commits.add_participants_commit(commit, participants)
    end
    self
  end

  def create_commit_from_log_entry(logentry, repository)
    commit = Commit.new
    commit.repository = repository
    commit.revision = logentry.attributes["revision"]
    commit.author = logentry.elements["author"].text
    commit.message = logentry.elements["msg"].text
    commit.date = DateTime.parse(logentry.elements["date"].text)
    commit.changes = create_commit_changes_from_log_entry(logentry)
    commit
  end

  def create_commit_changes_from_log_entry(logentry)
    changes = []
    logentry.elements.each("*/path") { |path|
      change = Change.new
      change.type = :modified
      changes << change
    }
    changes
  end

  def commits
    @commits
  end
end
