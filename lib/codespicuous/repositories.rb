
class Repository

  attr_accessor :url
  attr_reader :name

  def initialize(name)
    @name = name
  end

end

class Repositories

  def initialize(initial_repository_names = [])
    @repositories = {}

    [initial_repository_names].flatten.each { |name|
      @repositories[name] = Repository.new(name)
    }
  end

  def add repository
    @repositories[repository.name] = repository
  end

  def amount
    @repositories.size
  end
end

