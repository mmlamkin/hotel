module Hotel
  class Room
    attr_reader :room_number, :price
    attr_accessor :status, :reserved_dates

    def initialize(room_number)
      @room_number = room_number
      @price = 200
      @status = :available
      @reserved_dates = []
    end

    # def reserve(reservation_date)
    #   @reserved_dates << reservation_date
    # end
    #
    # def status?(date)
    #   if @reserved_dates.include?(date)
    #     @status = :unavailable
    #   else
    #     @status = :available
    #   end
    # end

  end
end
