
class Repository

  attr_accessor :url, :name

  def initialize(name, url)
    @name = name
    @url = url
  end

end

class Repositories

  def initialize
    @repositories = {}
  end

  def add repository
    @repositories[repository.name] = repository
  end

  def repository_by_name name
    @repositories[name]
  end

  def amount
    @repositories.size
  end

  def each
    @repositories.values.each { |repository|
      yield repository
    }
  end

  def [](index)
    @repositories.values[index]
  end
end

