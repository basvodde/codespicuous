
require 'rexml/document'

class SVNLogParser

  attr_accessor :participants, :repository

  def initialize
    @commits = Commits.new
  end

  def xml_to_parse(xml_string)
    @xml_to_parse = xml_string
  end

  def parse(xml_to_parse = nil)
    @xml_to_parse = xml_to_parse if xml_to_parse

    xml = REXML::Document.new(@xml_to_parse)
    validate_xml(xml)

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
      change.type = :modified if path.attributes["action"] == "M"
      change.type = :added if path.attributes["action"] == "A"
      change.file = path.text
      changes << change
    }
    changes
  end

  def validate_xml(xml)
    non_logentries = xml.elements["log"].elements.collect { |e| e.name unless e.name == "logentry" }.compact
    non_logentries.each { |e| raise("Unexpected log entry: " + e) }

    xml.elements.each( "*/logentry" ) do |logentry|
      validate_log_entry(logentry)
    end
  end

  def validate_log_entry logentry
    invalid_attributes = logentry.attributes.collect { |a| a[0] unless a[0] == "revision" }.compact
    invalid_attributes.each { |a| raise ("Unexpected attributes log entry: " + a) }

    invalid_elements = logentry.elements.collect { |e| e.name unless ["author", "date", "paths", "msg"].include? e.name }.compact
    invalid_elements.each { |e| raise ("Unexpected element in log entry: " + e) }

    logentry.elements.each("*/path") { |path|
      validate_path path
    }
  end

  def validate_path path
    path.elements.each { |e| raise ("Unexpected element in path: " + e.name) }

    invalid_attributes = path.attributes.collect { |a| a[0] unless ["action", "prop-mods", "text-mods", "kind"].include? a[0] }.compact
    invalid_attributes.each { |a| raise ("Unexpected attributes in path: " + a) }

    raise("Unexpected value to attribute action in path: " + path.attributes["action"]) unless ["M", "A"].include?(path.attributes["action"])
    raise("Unexpected value to attribute prop-mods in path: " + path.attributes["prop-mods"]) unless path.attributes["prop-mods"] == "false"
    raise("Unexpected value to attribute text-mods in path: " + path.attributes["text-mods"]) unless path.attributes["text-mods"] == "true"
    raise("Unexpected value to attribute kind in path: " + path.attributes["kind"]) unless path.attributes["kind"] == "file"
  end

  def commits
    @commits
  end
end
