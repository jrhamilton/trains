require './lib/train_line.rb'
require './lib/train_station.rb'
require './lib/stop.rb'
require './interface_methods.rb'
require 'pg'

DB = PG.connect(:dbname => 'trains')

def user_menu
  puts "Welcome to the Train Database!"
  puts "\n"
  puts "'C' for Station related searches"
  puts "'L' for All Stations on a Line"
  puts "Enter the secret code to get to the admin menu"
  puts "'X' to exit the database"
  prompt
  case choice = gets.chomp.upcase
  when 'C'
    clear
    city_search_menu
  when 'L'
    clear
    line_search_menu
  when 'HEISENBERG'
    clear
    main_menu
  when 'X'
    clear
  else
    puts "Invalid input"
    clear
    user_menu
  end
end

def city_search_menu
  puts "What Station would you like to go to?"
  prompt
  to = gets.chomp
  results = DB.exec("SELECT * from stops where station = '#{to}';")
  @stops = stop_eacher(results)
  @stops.each do |station|
    puts "Station: #{station.station} - Time: #{station.time} - Dir: #{station.dir} - Line: #{station.line}"
  end
  puts "\n"
  user_menu
end

def line_search_menu
  Line.puts_all
  puts "What Line do you want to view"
  prompt
  line_choice = gets.chomp
  results = DB.exec("SELECT * FROM stops WHERE line = '#{line_choice}'")
  lines = stop_eacher(results)
  puts "Here are the stops on the #{line_choice} line."
  lines.each do |station|
    puts "Station: #{station.station} - Time: #{station.time} - Dir: #{station.dir}"
  end
  puts "\n"
  user_menu
end

def main_menu
  clear
  puts "'S' for all Stations."
  puts "'L' for all Lines."
  puts "'STOP' for all stops"
  puts "'X' to exit."
  prompt
  case choice = gets.chomp.upcase
    when 'S'
      station_menu
    when 'L'
      lines_menu
    when 'X'
      puts "Stay blue my fiends!"
    when 'STOP'
      stop_menu
  else
    "Try again"
    main_menu
  end
end

def station_menu
  puts "'A' for Add a Station."
  puts "'E' to Edit a Station."
  puts "'D' to Delete a Station"
  puts "'V' to View all Stations"
  puts "'B' to go back to the main menu"
  prompt
  case choice = gets.chomp.upcase
  when 'A'
    puts "what is your new station name"
    prompt
    station = gets.chomp
    new_station = Station.new(station)
    new_station.save
    clear
    puts "#{new_station.station} has been saved"
    station_menu
  when 'E'
    puts "Which station to edit"
    prompt
    old_name = gets.chomp
    puts "What is new name"
    prompt
    new_name = gets.chomp
    DB.exec("UPDATE stations set station = '#{new_name}' where station = '#{old_name}'")
    clear
    puts "Station updated"
    station_menu
  when 'D'
    puts "Which station to delete"
    prompt
    station = gets.chomp
    DB.exec("DELETE from stations WHERE station = '#{station}'")
    clear
    puts "#{station} has be removed"
    station_menu
  when 'V'
    Station.puts_all
    station_menu
  when 'B'
    clear
    main_menu
  else
    clear
    puts "Try again"
    station_menu
  end
end

def lines_menu
  puts "'A' for Add a Line."
  puts "'E' to Edit a Line."
  puts "'D' to Delete a Line"
  puts "'V' to View all Lines"
  puts "'B' to go back to the main menu"
  prompt
  case choice = gets.chomp.upcase
  when 'A'
    puts "what is your new line name"
    line = gets.chomp
    new_line = Line.new(line)
    new_line.save
    clear
    puts "#{new_line.line} has been saved"
    lines_menu
  when 'E'
    puts "Which line to edit"
    prompt
    old_name = gets.chomp
    puts "What is new name"
    prompt
    new_name = gets.chomp
    DB.exec("UPDATE lines set line = '#{new_name}' where line = '#{old_name}'")
    clear
    puts "line updated"
    lines_menu
  when 'D'
    puts "Which line to delete"
    prompt
    line = gets.chomp
    DB.exec("DELETE from lines WHERE line = '#{line}'")
    clear
    puts "#{line} has been removed"
    lines_menu
  when 'V'
    Line.puts_all
    lines_menu
  when 'B'
    clear
    main_menu
  else
    clear
    puts "Try again"
    lines_menu
  end
end

def stop_menu
  puts "'A' for Add a Stop."
  puts "'E' to Edit a Stop."
  puts "'D' to Delete a Stop"
  puts "'V' to View all Stops"
  puts "'B' to go back to the main menu"
  prompt
  case choice = gets.chomp.upcase
  when 'A'
    clear
    add_stop
  when 'E'
    clear
    edit_stop
  when 'D'
    clear
    delete_stop
  when 'B'
    clear
    main_menu
  when 'V'
    Stop.puts_all
    stop_menu
  end
end

def add_stop
  Line.puts_all
  puts "Which line do you want to add to this stop?"
  prompt
  line = gets.chomp
  clear
  puts "Which station do you want to add to this stop?"
  Station.puts_all
  prompt
  station = gets.chomp
  l_name = line_validator(line)
  s_name = station_validator(station)
  puts "What time is this stop at"
  prompt
  time = gets.chomp
  puts "What direction"
  prompt
  dir = gets.chomp

  if l_name && s_name
    DB.exec("insert into stops (station, line, time, dir) values ('#{station}', '#{line}', '#{time}', '#{dir}');")
    clear
    puts "Stop added at #{station} station for the #{line} line!"
    stop_menu
  else
    clear
    puts "One of your inputs do not exist! Please create the line or station first"
    main_menu
  end
end

def edit_stop
  Stop.puts_all
  puts "Which Stop Number to edit?"
  prompt
  stop_id_no_i = gets.chomp
  if stop_id_no_i != ''
    stop_id = stop_id_no_i.to_i
    stop = Stop.get_stop(stop_id)
    puts "Current Station is #{stop.station}. Type new name or leave blank to keep same name"
    new_station = gets.chomp
    if new_station != ''
      if station_validator(new_station)
        DB.exec("update stops set station = '#{new_station}' where id = #{stop.id};")
        puts "New station name is #{new_station}"
      else
        clear
        puts "Try again"
        edit_stop
      end
    end
    puts "Current Line is #{stop.line}. Type new Line name or leave blank to keep same line name."
    prompt
    new_line = gets.chomp
    if new_line != ''
      if line_validator(new_line)
        DB.exec("UPDATE stops SET line = '#{new_line}' WHERE id = #{stop.id};")
        puts "New Line name is #{new_line}"
      else
        clear
        puts "Try again"
        edit_stop
      end
    end
    puts "Current Time is #{stop.time}. Type new Time or leave blank to keep same time."
    prompt
    new_time = gets.chomp
    if new_time != ''
      DB.exec("UPDATE stops SET time = '#{new_time}' WHERE id = #{stop.id};")
      puts "New Time is #{new_time}"
    end
    puts "Current directions is #{stop.dir}. Type new Direction or leave blank to keep same direction."
    prompt
    new_dir = gets.chomp
    if new_dir != ''
      DB.exec("UPDATE stops SET dir = '#{new_dir}' WHERE id = #{stop.id};")
      puts "New Direction is #{new_dir}"
    end
    stop_menu
  else
    clear
    main_menu
  end
end

def delete_stop
  Stop.puts_all
  puts "Which Stop ID to delete"
  prompt
  stop_id = gets.chomp.to_i
  DB.exec("DELETE FROM stops WHERE id = #{stop_id};")
  clear
  puts "The Stop has been Nuked"
  stop_menu
end



user_menu
