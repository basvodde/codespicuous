
require 'rexml/document'

class SVNLogParser

  attr_accessor :repository

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
      @commits.add(commit)
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

  def extract_change_type(path)
    return :modified if path.attributes["action"] == "M"
    return :added if path.attributes["action"] == "A"
    return :deleted if path.attributes["action"] == "D"
    return :renamed if path.attributes["action"] == "R"
  end

  def extract_kind(path)
    return :file if path.attributes["kind"] == "file"
    return :dir if path.attributes["kind"] == "dir"
  end

  def create_commit_changes_from_log_entry(logentry)
    changes = []
    logentry.elements.each("*/path") { |path|
      change = Change.new
      change.type = extract_change_type(path)
      change.kind = extract_kind(path)
      change.property_changed if  path.attributes["prop-mods"] == "true"
      change.copyfrom = path.attributes["copyfrom-path"]
      change.copyrev = path.attributes["copyfrom-rev"]
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

    invalid_attributes = path.attributes.collect { |a| a[0] unless ["action", "prop-mods", "text-mods", "kind", "copyfrom-path", "copyfrom-rev"].include? a[0] }.compact
    invalid_attributes.each { |a| raise ("Unexpected attributes in path: " + a) }

    raise("Unexpected value to attribute action in path: " + path.attributes["action"]) unless ["R", "M", "A", "D"].include?(path.attributes["action"])
    raise("Unexpected value to attribute kind in path: " + path.attributes["kind"]) unless ["file", "dir"].include?(path.attributes["kind"])

    puts "Unexpected value to attribute text-mods in path: " + path.attributes["text-mods"] if path.attributes["text-mods"] == "false" and not ["D", "R"].include?(path.attributes["action"]) and path.attributes["kind"] != "dir"
  end

  def commits
    @commits
  end
end
