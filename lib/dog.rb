class Dog
  attr_accessor :id,:name, :breed

  def initialize(id:nil, name:,breed:)
    @name, @breed=name,breed
  end

  def create_table(name, breed)
  end

end
