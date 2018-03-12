require_relative './lib/admin'
require_relative './lib/reservation'
require_relative './lib/room'
require_relative './lib/block'
require 'date'


def  greeting
  puts "What would you like to do?"

  puts "  1. Reserve a room\n
  2. See list of available rooms\n
  3. Create a Block (max of 5 rooms)\n
  4. Reserve a room from an existing block\n
  5. See available rooms in a block\n
  6. Find an existing reservation\n
  7. Find an existing block\n
  8. Exit\n"
end

front_desk = Hotel::Admin.new

puts "~~~~~~Front Desk~~~~~~\n\n"

greeting

loop do

  user_choice = gets.chomp.to_i

  until user_choice < 9 && user_choice != 0
    puts "Not a valid choice"
    greeting
    user_choice = gets.chomp.to_i
  end

  if user_choice == 1
    print "\nWhat is the check in date? "
    start_date = gets.chomp
    start_date = Date.parse(start_date)
    print "What is the check out date? "
    end_date = gets.chomp
    end_date = Date.parse(end_date)
    reservation = front_desk.reserve_room(start_date, end_date)
    puts "\nThank you for booking, your Reservaion ID is #{reservation.id} and you will be staying in Room #{reservation.room.room_number}."

  elsif user_choice == 2
    print "\nWhat is the check in date? "
    start_date = gets.chomp
    start_date = Date.parse(start_date)
    print "What is the check out date? "
    end_date = gets.chomp
    end_date = Date.parse(end_date)
    avail_rooms = front_desk.available_rooms(start_date, end_date)
    avail_rooms.each do |room|
      puts room.room_number
    end

  elsif user_choice == 3
    print "\nHow many rooms would you like to reserve? "
    num_rooms = gets.chomp.to_i
    print "What is the check in date? "
    start_date = gets.chomp
    start_date = Date.parse(start_date)
    print "What is the check out date? "
    end_date = gets.chomp
    end_date = Date.parse(end_date)
    block = front_desk.reserve_block(start_date, end_date, num_rooms)
    room_nums = block.room.map do |room|
      room.room_number
    end
    print "\nThank you, your Block ID is #{block.id} and your rooms are #{room_nums}."

  elsif user_choice == 4
    "\nWhat is the Block ID?"
    block_id = gets.chomp.to_i
    front_desk.reserve_blocked_room(block_id)
    puts "\nYou booked a room in Block #{block_id}"

  elsif user_choice == 5
    puts "\nWhat is the Block ID?"
    block_id = gets.chomp.to_i
    rooms = front_desk.blocks[block_id - 1].room
    puts "#{block_id}'s available rooms are #{rooms}"

  elsif user_choice == 6
    puts "\nWhat is the Reservatin ID? "
    reservation_id = gets.chop.to_i
    reservation = front_desk.reservations[reservation_id - 1]
    start_date = reservation.dates[0]
    end_date = reservation.dates.last
    room = reservation.room
    puts "\nYour reservation is from #{start_date} to #{end_date} in Room #{room}"

  elsif user_choice == 7
    puts "\nWhat is the Block ID? "
    block_id = gets.chop.to_i
    block = front_desk.blocks[block_id - 1]
    start_date = block.dates[0]
    end_date = block.dates.last
    room = block.room
    puts "\nYour block is for rooms #{room} from #{start_date} to #{end_date}."

  else user_choice == 8
    break
  end

  puts "\nWould you like to continue? Y/N "
  choice = gets.chomp.upcase
  if choice == "Y"
    greeting
  else choice == "N"
    break
  end
end
