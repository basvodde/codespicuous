

class RepositoryLister

  def list(commit_history)

    teams_and_repositories = collect_teams_and_repositories_they_committed_to(commit_history)

    if teams_and_repositories.empty?
      puts "No teams committed in any of the repositories"
      return
    end

    print_teams_commit_to_which_repository(teams_and_repositories)
  end

  def collect_teams_and_repositories_they_committed_to(commit_history)
    teams_and_repositories = {}
    commit_history.teams.each do |team|
      repositories = team.committed_repositories
      teams_and_repositories[team.name] = repositories unless repositories.empty?
    end
    teams_and_repositories
  end

  def print_teams_commit_to_which_repository(teams_and_repositories)
    teams_and_repositories.each do |team, repositories|
      repositories_string = ""
      repositories.each do |repository|
        repositories_string += "  " + repository.name + "\n"
      end
      puts "Team \"#{team}\" committed in:\n" + repositories_string
    end
  end
end
