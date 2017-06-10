
class DanielFormatParser

  attr_reader :teams, :commits, :commit_history

  def parse committers_daniel_format

    @teams = Teams.new
    @commits = Commits.new
    @commit_history = CommitHistory.new

    current_repository = current_committer = ""

    committers_daniel_format.each_line { |line|

      if /repository: (.*)/.match(line)
        current_repository = Repository.new($~[1], "")
      elsif /\*\*\* (.*)/.match(line)
        current_committer = $~[1]
      elsif /team:(.*)/.match(line)
        team = @teams.team($~[1].strip)
        team.member(current_committer)
      elsif /  (.*): (.*) commits/.match(line)
        amount_of_commits = $~[2]
        amount_of_commits.to_i.times {
          commit = Commit.new
          commit.author = current_committer
          commit.repository = current_repository
          commit.date = $~[1]
          @commits.add(commit)
          @commit_history.add_commits(@commits)
        }
      end
    }
  end
end
