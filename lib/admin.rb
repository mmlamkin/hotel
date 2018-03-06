require 'time'
require 'date'
require 'pry'

require_relative 'room'
require_relative 'reservation'

module Hotel
  class Admin
    attr_reader :rooms
    attr_accessor :reservations


    def initialize
      @rooms = all_rooms
      @reservations = []
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

    # def find_room
    #   room = @rooms.find { |room| room.status == :available }
    #   room.status = :unavailable
    #   return room
    # end

    def reserve_room(start_date, end_date)
      room = available_rooms(start_date, end_date)[0]
      reservation = Hotel::Reservation.new(start_date, end_date, room)

      room.status = :unavailable
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

    def reservation_cost(reservation)
      if @reservations.include?(reservation) == false || @reservations.length == 0 || reservation.class != Hotel::Reservation
        raise ArgumentError.new("Not a valid reservation")
      else
        return reservation.cost
      end
    end

    def available_rooms(start_date, end_date)
      unavailable_rooms = []
      res_dates = (start_date..end_date).to_a

      res_dates.each do |date|
        find_reservations(date).each do |reservation|
          if res_dates.first == reservation.dates.last
          else
            unavailable_rooms << reservation.room
          end
        end
      end
      if unavailable_rooms.length == 20
        raise ArgumentError.new('No available rooms')
      else
        return ( @rooms - unavailable_rooms )
      end
    end
  end
end
