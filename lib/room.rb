module Hotel
  class Room
    attr_reader :room_number, :price


    def initialize(room_number)
      @room_number = room_number
      @price = 200
    end

  end
end
