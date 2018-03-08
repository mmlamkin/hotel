require 'time'
require 'date'
require 'pry'

require_relative 'room'
require_relative 'reservation'

module Hotel
  class Admin
    attr_reader :rooms, :reservations

    def initialize
      @rooms = all_rooms
      @reservations = []
      @blocks = []
    end

    def all_rooms
      room_array = []
      x = 1
      20.times do
        room_array << Hotel::Room.new(x)
        x += 1
      end
      return room_array
    end

    def reserve_room(start_date, end_date)
      if available_rooms(start_date, end_date).empty?
        raise StandardError.new('no available rooms')
      end

      room = available_rooms(start_date, end_date)[0]
      id = ( @reservations.length + 1 )
      reservation = Hotel::Reservation.new(start_date, end_date, room, id)

      @reservations << reservation

      return reservation
    end

    def find_reservations(date)
      reservations_by_date = []
      @reservations.each do |reservation|
        if reservation.dates.include?(date)
          reservations_by_date << reservation
        end
      end
      return reservations_by_date
    end

    def reservation_cost(reservation_id)
      if @reservations.empty? || reservation_id.class != Integer || reservation_id < 1 || @reservations[reservation_id - 1] == nil || reservation_id == nil
        raise ArgumentError.new("Not a valid Reservation id")
      end

      return @reservations[reservation_id - 1].cost

    end

    def available_rooms(start_date, end_date)
      unavailable_rooms = []
      res_dates = (start_date..end_date).to_a

      res_dates.each do |date|
        find_reservations(date).each do |reservation|
          unavailable_rooms << reservation.room
        end
      end

      res_dates.each do |date|
        find_block(date).each do |block|
          unavailable_rooms << block.room
        end
      end

      unavailable_rooms = unavailable_rooms.flatten.uniq

      return ( @rooms - unavailable_rooms )
    end

    def reserve_block(start_date, end_date, num_rooms)
      if num_rooms > 5
        raise ArgumentError.new("Blocks cannot be greater than 5 rooms")
      end

      if available_rooms(start_date, end_date).length < num_rooms
        raise StandardError.new("Not enough available rooms")
      end

      rooms = available_rooms(start_date, end_date).take(num_rooms)
      id = @blocks.length + 1

      new_block = Hotel::Block.new(start_date, end_date, rooms, id)

      @blocks << new_block
      return new_block
    end

    def find_block(date)
      block_by_date = []
      @blocks.each do |block|
        if block.dates.include?(date)
          block_by_date << block
        end
      end
      block_by_date.uniq!
      return block_by_date
    end

    def reserve_blocked_room(block_id)
      if @blocks.empty? || block_id.class != Integer
        raise ArgumentError("Not a valid Block id")
      end
      @blocks[block_id - 1].reserve_room
    end

    def block_available_rooms(block_id)
      if @blocks.empty? || block_id.class != Integer || block_id < 1
        raise ArgumentError.new("Not a valid Block id")
      end
      @blocks[block_id - 1].room
    end
  end
end
