require 'date'
require_relative 'room'
require_relative 'reservation'
require 'pry'

module Hotel
  class Block < Reservation
    attr_reader :room, :dates, :booked_rooms, :id

    def initialize(start_date, end_date, room, id)
      super
      @booked_rooms = []
    end

    def cost
      super * 0.8
    end

    def reserve_room
      @booked_rooms << @room[0]
      @room.shift
    end
  end
end
