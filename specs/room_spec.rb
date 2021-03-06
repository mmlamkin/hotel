require_relative 'spec_helper'

describe 'Room Class' do
  describe 'initialize' do

    before do
      @room = Hotel::Room.new(1)
    end

    it 'returns an instance of room' do
      @room.must_be_instance_of Hotel::Room
    end

    it 'has a default price of $200/night' do
      @room.price.must_equal 200
    end

    it 'has a room number' do
      @room.room_number.must_equal 1
    end
  end

end
