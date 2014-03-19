class Station
  attr_reader :station

  def initialize(station)
    @station = station
  end

  def save
    DB.exec("insert into stations (station) values ('#{@station}');")
  end

  def self.all
    result = DB.exec("SELECT * FROM stations")
    stations = []
    result.each do |station|
      station = station['station']
      stations << Station.new(station)
    end
    stations
  end

  def self.puts_all
    self.all.each do |obj|
      puts obj.station.to_s
    end
  end

  def ==(another_station)
    self.station == another_station.station
  end

end
