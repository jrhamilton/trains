def line_validator(line)
  results = DB.exec("select * from lines where line = '#{line}';")
  @lines = []
  results.each do |obj|
    @lines << obj['line']
  end
  @lines.length > 0
end

def station_validator(station)
  station = DB.exec("select * from stations where station = '#{station}';")
  @stations = []
  station.each do |obj|
    @stations << obj['station']
  end
  @stations.length > 0
end

def stop_eacher(results)
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

def clear
  system('clear')
end

def prompt
  print "> "
end
