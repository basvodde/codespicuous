
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

end

class Teams

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
    @teams.values.each { |team|
      yield team
    }
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
end

