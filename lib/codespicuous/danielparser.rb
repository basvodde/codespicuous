
class DanielFormatParser

  def parse committers_daniel_format

    stats = CommitStatistics.new
    current_repository = current_committer = ""

    committers_daniel_format.each_line { |line|

      if /repository: (.*)/.match(line)
        current_repository = $~[1]
      elsif /\*\*\* (.*)/.match(line)
        current_committer = $~[1]
      elsif /team:(.*)/.match(line)
        stats.committer(current_committer).team = $~[1].strip
      elsif /  (.*): (.*) commits/.match(line)
        stats.commit(current_committer, current_repository, $~[1], $~[2])
      end
    }
    stats
  end
end
