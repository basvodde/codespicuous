
class DanielFormatParser

  def parse committers_daniel_format

    commit_history = CommitHistory.new

    current_repository = current_author = ""

    committers_daniel_format.each_line { |line|

      if /repository: (.*)/.match(line)
        current_repository = Repository.new($~[1], "")
      elsif /\*\*\* (.*)/.match(line)
        current_author = $~[1]
      elsif /team:(.*)/.match(line)
        commit_history.add_team_member($~[1].strip, current_author)
      elsif /  (.*): (.*) commits/.match(line)
        amount_of_commits = $~[2]
        amount_of_commits.to_i.times {
          commit = Commit.new
          commit.author = current_author
          commit.repository = current_repository
          commit.date = $~[1]
          commit_history.add_commit(commit)
        }
      end
    }
    commit_history
  end
end
