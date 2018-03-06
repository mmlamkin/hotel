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
      20.times do
        x = 1
        room_array << Hotel::Room.new(x)
        x += 1
      end
      return room_array
    end

    def find_room
      room = @rooms.find { |room| room.status == :available }
      room.status = :unavailable
      return room
    end

    def reserve_room(start_date, end_date)
      room = find_room
      reservation = Hotel::Reservation.new(start_date, end_date, room)

      @reservations << reservation
      # reservation.dates.each do |date|
      #   if @reservations.keys.include?(date) == true
      #     @reservations[date] << reservation
      #   else
      #     @reservations[date] = [reservation]
      #   end
      # end
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
      reservation.cost
    end
  end
end
