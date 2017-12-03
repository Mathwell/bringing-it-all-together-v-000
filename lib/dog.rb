class Dog
  attr_accessor :id,:name, :breed

  def initialize(id:nil, name:,breed:)
    @name, @breed=name,breed
  end

  def self.create_table
    sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs (
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
     )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS dogs"
    DB[:conn].execute(sql)
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
         INSERT INTO dogs (name, breed)
         VALUES (?, ?)
       SQL

       DB[:conn].execute(sql, self.name, self.breed)
       @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
    self
  end

  def self.create(name)
    dog=Dog.new
    dog.name=name
    dog.save
    dog
  end

  def self.find_by_id(id)
    sql = <<-SQL
     SELECT *
     FROM dogs
     WHERE id = ?
   SQL
   DB[:conn].execute(sql, id).map do |row|
     self.new_from_db(row)
   end.first
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    dog=create(row[1])
    dog.id=row[0]
    dog
  end

end
