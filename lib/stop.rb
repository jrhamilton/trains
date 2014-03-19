class Stop
 attr_reader :id, :station, :line, :time, :dir
  def initialize(id, station, line, time, dir)
    @id = id
    @station = station
    @line = line
    @time = time
    @dir = dir
  end

  def self.all
    results = DB.exec("SELECT * FROM stops;")
    @stops = []
    results.each do |stop|
      id = stop['id']
      station = stop['station']
      line = stop['line']
      time = stop['time']
      dir = stop['dir']
      @stops << Stop.new(id, station, line, time, dir)
    end
    @stops
  end

  def save
    DB.exec("insert into stops (id, station, line, time, dir) values ('#{@id}',
      '#{@station}', '#{@line}', '#{@time}', '#{@dir}');")
  end

  def self.puts_all
    self.all.each do |stop|
      puts " No. - #{stop.id.to_s}, Station - #{stop.station}, Line - #{stop.line},
      Time - #{stop.time}, Dir - #{stop.dir}"
    end
  end

  def self.get_stop(stop_id)
  result = DB.exec ("SELECT * FROM stops WHERE id = #{stop_id};")
  @answer = []
  result.each do |result|
    @answer << result
  end
  @new_answer = @answer[0]
  Stop.new(@new_answer['id'], @new_answer['station'], @new_answer['line'], @new_answer['time'], @new_answer['dir'])
  end

  def ==(another_stop)
    self.id == another_stop.id && self.station == another_stop.station && self.line == another_stop.line && self.time == another_stop.time && self.dir == another_stop.dir
  end

end
