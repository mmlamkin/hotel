require_relative 'spec_helper'

describe 'Block Class' do
  before do
    start_date = Date.parse('2018-04-01')
    end_date = Date.parse('2018-04-05')
    @room = [Hotel::Room.new(1), Hotel::Room.new(2)]
    @block = Hotel::Block.new(start_date, end_date, @room, 1)
  end

  describe 'initialize' do

    it 'creates an instance of Hotel::Block' do
      @block.must_be_instance_of Hotel::Block
    end

    it 'has a date range' do
      @block.dates.must_be_kind_of Array
      @block.dates[0].must_be_instance_of Date
      @block.dates.length.must_equal 4
    end

    it 'has an array of assigned rooms' do
      @block.room.must_be_instance_of Array
      @block.room[0].must_be_instance_of Hotel::Room
    end

    it 'returns an error for invalid dates' do

      proc {
        Hotel::Block.new('2018-04-01', Date.parse('2018-04-05'), @room)
      }.must_raise ArgumentError

      proc {
        Hotel::Block.new(Date.parse('2018-04-05'), Date.parse('2018-04-01'), @room)
      }.must_raise ArgumentError

      proc {
        Hotel::Block.new(Date.parse('2018-02-05'), Date.parse('2018-04-05'), @room)
      }.must_raise ArgumentError
    end

    it 'keeps track of booked rooms' do
      @block.booked_rooms.must_be_kind_of Array
    end
  end

  describe 'cost' do

    it 'returns total cost per room' do
      @block.cost.must_be_kind_of Float
      @block.cost.must_equal 800.00 * 0.8
    end
  end

  describe 'reserve_room' do
    it 'adds a room to @booked_rooms and removes from blocked rooms' do
      @block.room.length.must_equal 2
      @block.reserve_room
      @block.booked_rooms.length.must_equal 1
      @block.room.length.must_equal 1
    end

  end


end
