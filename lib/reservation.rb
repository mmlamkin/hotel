require 'date'
require_relative 'room'

module Hotel
  class Reservation
    attr_reader :room, :dates

    def initialize(start_date, end_date, room)
      # if Date.valid_date?(start_date) == false || Date.valid_date?(end_date) == false
      #   raise ArgumentError.new("Invalid start or end date")
      # end

      if end_date < start_date
        raise ArgumentError.new("End date must be after start date")
      end

      if start_date < Date.today
        raise ArgumentError.new("start of stay must be after today")
      end

      @room = room
      @dates = to_date(start_date, end_date)

    end

    def to_date(start_date, end_date)
      dates = (start_date..end_date).to_a
      return dates
    end

    def cost
      total = ( dates.length - 1 ) * 200
      return total.round(2)
    end
  end
end
