
class Team

  attr_accessor :name

  def initialize(name)
    @name = name
    @members = {}
  end

  def add_member(member)
    @members[member.username] = member
    member.team = self
  end

  def add_members(members)
    members.each { |member| add_member(member) }
  end

  def members
    @members.values
  end

  def each_member
    @members.values.each { |member|
      yield member
    }
  end

  def amount_of_members
    @members.size
  end

  def member_usernames
    @members.keys
  end

  def <=> other
    @name <=> other.name
  end

  def ==(team)
    name == team.name && members == team.members
  end

  def committed_repositories

    repositories = []

    each_member do |member|
      repositories += member.committed_repositories
    end
    repositories.uniq
  end
end

class Teams

  attr_reader :teams

  def initialize
    @teams = {}
  end

  def find_by_name(name)
    @teams[name]
  end

  def team_names
    @teams.keys
  end

  def each
    @teams.values.sort.each { |team|
      yield team
    }
  end

  def committers
    committers = Committers.new
    each_member { |team, committer| committers.add(committer) }
    committers
  end

  def empty?
    @teams.empty?
  end

  def map(&block)
    @teams.values.map(&block)
  end

  def each_member
    @teams.values.each { |team|
      team.each_member { |member|
        yield team, member
      }
    }
  end

  def team(name)
    @teams[name] ||= Team.new(name)
  end

  def add(team)
    @teams[team.name] = team
  end

  def amount
    @teams.size
  end

  def member_usernames(team_name = nil)
    @teams.values.collect { |team|
      team.member_usernames if team.name == team_name || team_name == nil
    }.compact.flatten
  end

  def ==(teams)
    @teams == teams.teams
  end
end

