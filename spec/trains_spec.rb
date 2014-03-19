require 'pg'
require 'rspec'
require 'train_station'
require 'train_line'

 DB = PG.connect(:dbname => 'trains_test')

 RSpec.configure do |config|
  config.after(:each) do
    DB.exec("DELETE FROM lines *;")
    DB.exec("DELETE FROM stations *;")
  end
end

describe Station do
  it 'initializes the Station object' do
    sl = Station.new("station")
    sl.should be_an_instance_of Station
  end

  it 'lets you save lines to the database' do
    s1 = Station.new('station')
    s1.save
    Station.all.should eq [s1]
  end
end


describe Line do
  it 'initializes the Line object' do
    tl = Line.new("line")
    tl.should be_an_instance_of Line
  end

  it 'lets you save lines to the database' do
    l1 = Line.new('line1')
    l1.save
    Line.all.should eq [l1]
  end
end
