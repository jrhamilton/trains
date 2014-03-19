class Line
  attr_reader :line

  def initialize(line)
    @line = line
  end

  def save
    DB.exec("insert into lines (line) values ('#{@line}');")
  end

  def self.all
    result = DB.exec("SELECT * FROM lines")
    lines = []
    result.each do |line|
      line = line['line']
      lines << Line.new(line)
    end
    lines
  end

  def self.puts_all
    self.all.each do |obj|
      puts obj.line.to_s
    end
  end

  def ==(another_line)
    self.line == another_line.line
  end

end


