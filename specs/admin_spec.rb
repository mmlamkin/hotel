require_relative 'spec_helper'

describe "Admin class" do
  before do
    @admin = Hotel::Admin.new
    @start_date = Date.parse('2018-04-01')
    @end_date = Date.parse('2018-04-05')
  end

  describe "initialize" do
    it 'creates an instance of Admin' do
      @admin.must_be_instance_of Hotel::Admin
    end

    it 'holds an array of room instances' do
      @admin.rooms.must_be_kind_of Array
      @admin.rooms.length.must_equal 20
      @admin.rooms[0].must_be_instance_of Hotel::Room
      @admin.rooms[0].room_number.must_equal 1
    end

    it 'has an array of reservations' do
      @admin.reservations.must_be_instance_of Array
    end
  end

  describe 'reserve room' do
    it 'creates an instance of Reservation' do
      @admin.reserve_room(@start_date, @end_date).must_be_instance_of Hotel::Reservation
    end

    it 'adds reservation information to @reservations' do
      @admin.reservations.length.must_equal 0
      @admin.reserve_room(@start_date, @end_date)
      @admin.reservations.length.must_equal 1
    end

    it 'does not allow overlapping room reservations' do
      res_one = @admin.reserve_room(@start_date, @end_date)
      res_two = @admin.reserve_room(@start_date, @end_date)
      res_three = @admin.reserve_room(@start_date + 1, @end_date + 3)
      res_four = @admin.reserve_room(@start_date - 4, @end_date + 3)
      res_five = @admin.reserve_room(@start_date + 1, @end_date - 1)
      res_one.room.room_number.wont_equal res_two.room.room_number
      res_three.room.room_number.wont_equal res_two.room.room_number
      res_four.room.room_number.wont_equal res_one.room.room_number
      res_five.room.room_number.wont_equal res_one.room.room_number
    end

    it 'allows a room reservation to start on the same day another reservation ends' do
      @admin.reserve_room(@start_date, @end_date).room.room_number.must_equal 1
      @admin.reserve_room(@end_date, @end_date + 1).room.room_number.must_equal 1
    end

    it 'raises an error if there are no available rooms' do
      proc { 21.times do
        @admin.reserve_room(@start_date, @end_date)
      end }.must_raise StandardError
    end
  end

  describe 'find_reservations' do
    it 'returns an array of reservations' do
      @admin.find_reservations(@start_date).must_be_instance_of Array

      @admin.find_reservations(@start_date).length.must_equal 0

      @admin.reserve_room(@start_date, @end_date)

      @admin.find_reservations(@start_date)[0].must_be_instance_of Hotel::Reservation

      @admin.find_reservations(@start_date).length.must_equal 1
    end
  end

  describe 'reservation cost' do
    it 'returns the cost of the reservation' do
      reservation = @admin.reserve_room(@start_date, @end_date)
      id = reservation.id
      @admin.reservation_cost(id).must_equal 800.00
    end

    it 'throws an error if the reservation does not exist' do
      proc {
        @admin.reservation_cost()
      }.must_raise ArgumentError

      proc {
        @admin.reservation_cost('reservation')
      }.must_raise ArgumentError

      proc {
        @admin.reservation_cost(-1)
      }.must_raise ArgumentError

      proc {
        @admin.reservation_cost(4)
      }.must_raise ArgumentError
    end
  end

  describe 'available rooms' do
    before do
      @room_array = @admin.available_rooms(@start_date, @end_date)
    end

    it 'returns an array of rooms' do
      @room_array.must_be_kind_of Array
      @room_array[0].must_be_instance_of Hotel::Room
    end

    it 'does not return rooms that are in a block or other reservation' do           @admin.available_rooms(@start_date, @end_date).length.must_equal 20
      @admin.reserve_room(@start_date, @end_date)
      @admin.available_rooms(@start_date, @end_date).length.must_equal 19
      @admin.reserve_block(@start_date, @end_date, 4)
      @admin.available_rooms(@start_date, @end_date).length.must_equal 15
    end
  end

  describe 'reserve_block' do
    it 'creates new instance of Block' do
      @admin.reserve_block(@start_date, @end_date, 5).must_be_instance_of Hotel::Block
    end

    it 'raises an error for blocks of more than 5 rooms' do
      proc { @admin.reserve_block(@start_date, @end_date, 6) }.must_raise ArgumentError
    end

    it 'raises an error if there are not enough available rooms' do
      20.times do
        @admin.reserve_room(@start_date, @end_date)
      end

      proc { @admin.reserve_block(@start_date, @end_date, 3) }.must_raise StandardError
    end

    it 'does not allow overlapping room reservations' do
      block_one = @admin.reserve_block(@start_date, @end_date, 5)
      block_two = @admin.reserve_block(@start_date, @end_date, 5)
      block_three = @admin.reserve_block(@start_date + 2, @end_date + 10, 5)

      block_one.room[0].room_number.wont_equal block_two.room[0].room_number
      block_one.room[4].room_number.wont_equal block_two.room[4].room_number
      block_one.room[0].room_number.wont_equal block_three.room[0].room_number

      @admin.available_rooms(@start_date, @end_date).length.must_equal 5
    end
    it 'allows a a block of the same rooms to checkin on the checkout date of another block' do
      block_one = @admin.reserve_block(@start_date, @end_date, 5)
      block_two = @admin.reserve_block(@end_date, @end_date + 4, 5)

      block_one.room[0].room_number.must_equal block_two.room[0].room_number
    end
  end

  describe 'find_block' do
    it 'returns an array' do
      @admin.find_block(@start_date).must_be_kind_of Array
    end

    it 'returns all blocks that include a date' do
      @admin.find_block(@start_date).length.must_equal 0
      @admin.reserve_block(@start_date, @end_date, 5)
      @admin.find_block(@start_date).length.must_equal 1
      @admin.reserve_block(@start_date, @end_date, 3)
      @admin.find_block(@start_date).length.must_equal 2
    end

    describe 'reserve_blocked_room' do
      before do
        @block = @admin.reserve_block(@start_date, @end_date, 5)
      end

      it 'moves a room of that block into Hotel::Block @booked_rooms' do
        first_room = @block.room[0]
        @block.room.length.must_equal 5
        @block.booked_rooms.length.must_equal 0
        @admin.reserve_blocked_room(1)
        @block.room.length.must_equal 4
        @block.booked_rooms.length.must_equal 1
        @block.booked_rooms[0].must_equal first_room
      end

      it 'throws an error if given invalid id' do
        proc { @admin.block_available_rooms('') }.must_raise ArgumentError

        proc { @admin.block_available_rooms(-2) }.must_raise ArgumentError

        proc { @admin.block_available_rooms() }.must_raise ArgumentError

        proc { @admin.block_available_rooms("string") }.must_raise ArgumentError
      end
    end

    describe 'block_available_rooms' do
      before do
        @block = @admin.reserve_block(@start_date, @end_date, 5)
      end

      it 'returns a list of available rooms in a block' do
        @admin.block_available_rooms(1).must_be_kind_of Array
        @admin.block_available_rooms(1)[0].must_be_instance_of Hotel::Room
        @admin.block_available_rooms(1).length.must_equal 5
        @admin.reserve_blocked_room(1)
        @admin.block_available_rooms(1).length.must_equal 4
      end

      it 'throws an error if given invalid id' do
        proc { @admin.block_available_rooms('') }.must_raise ArgumentError

        proc { @admin.block_available_rooms(-2) }.must_raise ArgumentError

        proc { @admin.block_available_rooms() }.must_raise ArgumentError

        proc { @admin.block_available_rooms("string") }.must_raise ArgumentError
      end
    end
  end
end
