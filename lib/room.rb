module Hotel
  class Room
    attr_reader :room_number, :price
    attr_accessor :status

    def initialize(room_number)
      @room_number = room_number
      @price = 200
      @status = :available
    end

  end
end
