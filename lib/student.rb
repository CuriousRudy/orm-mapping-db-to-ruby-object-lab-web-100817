class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row) #working
    student = Student.new
    student.id = row[0]
    student.name = row[1]
    student.grade = row[2]
    student
  end

  def self.all #working - when returning SQL queries, we are getting an array, with the info we request, so we need to iterate over it, then instantiate it to read it
    sql = <<-SQL
    SELECT * FROM students
    SQL
    DB[:conn].execute(sql).map {|db_row| self.new_from_db(db_row)}

  end

  def self.find_by_name(name) #working - retrieve an array with the student information, iterate over to instantiate, then return the first value of the array (name)
    sql = <<-SQL
      SELECT * FROM students
    WHERE name = ?
    LIMIT 1
    SQL
    row = DB[:conn].execute(sql, name).map do |db_row|
      self.new_from_db(db_row)
    end
    row.first
  end

  def save #working
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.count_all_students_in_grade_9 #working
    sql = <<-SQL
    SELECT COUNT(name) FROM students
    WHERE grade = 9
    SQL
    row = DB[:conn].execute(sql).map do |student|
      student[0]
    end
  end

  def self.first_X_students_in_grade_10(number) #working
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT ?
    SQL
    DB[:conn].execute(sql, number)
  end

  def self.first_student_in_grade_10
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = 10
    LIMIT 1
    SQL
    row = DB[:conn].execute(sql).map do |student|
      self.new_from_db(student)
    end
    row.first
  end

  def self.students_below_12th_grade #working
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade < 12
    SQL
    DB[:conn].execute(sql)
  end

  def self.all_students_in_grade_X(grade) #working
    sql = <<-SQL
    SELECT * FROM students
    WHERE grade = ?
    SQL
    DB[:conn].execute(sql, grade)
  end

  def self.create_table #working
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table #working
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end
end
