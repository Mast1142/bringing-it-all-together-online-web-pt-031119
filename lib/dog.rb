require 'pry'

class Dog
  attr_accessor :id, :name, :breed

  def initialize(id: nil, name:, breed:)
    @id = id
    @name = name
    @breed = breed
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs(
      id INTEGER PRIMARY KEY,
      name TEXT,
      breed TEXT
    )
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute('DROP TABLE dogs')
  end

  def save
    if self.id
      self.update
    else
      sql = <<-SQL
      INSERT INTO dogs(name, breed)
      VALUES (?, ?)
      SQL
      DB[:conn].execute(sql, self.name, self.breed)
      @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    end
  end

  def update
    sql = "UPDATE dogs SET name = ?, breed = ? WHERE id = ?"
    DB[:conn].execute(sql, self.name, self.breed, self.id)
  end

  def self.create(name:, breed:)
    #binding.pry
    new_dog = self.new(name, breed)
    new_dog.save
    new_dog
  end

  # def self.new_from_db(row)
  #   new_student = self.new(row[1], row[2], row[0])
  #   new_student.id = row[0]
  #   new_student.name = row[1]
  #   new_student.grade = row[2]
  #   new_student
  # end
  #
  # def self.find_by_name(name)
  #   sql = <<-SQL
  #     SELECT *
  #     FROM students
  #     WHERE name = ?
  #     SQL
  #   DB[:conn].execute(sql, name).map do |row|
  #   #binding.pry
  #     self.new_from_db(row)
  #   end.first
  # end
end
