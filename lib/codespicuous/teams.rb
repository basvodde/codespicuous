
class Team

  attr_accessor :name

  def initialize(name)
    @name = name
    @members = {}
  end

  def add_member(member)
    @members[member.loginname] = member
  end

  def amount_of_members
    @members.size
  end

  def member_loginnames
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

  def team(name)
    @teams[name] ||= Team.new(name)
  end

  def amount
    @teams.size
  end

end
