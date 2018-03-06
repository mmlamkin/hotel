require_relative 'spec_helper'

describe "Admin class" do
  describe "initialize" do
    before do
      @admin =  Hotel::Admin.new
    end

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

  # describe 'find_room' do
  #   it 'returns an instance of room' do
  #     admin = Hotel::Admin.new
  #     admin.find_room.must_be_instance_of Hotel::Room
  #   end
  # #
  #   it 'returns an available room and changes status to unavailable' do
  #     admin = Hotel::Admin.new
  #     admin.rooms[0].status.must_equal :available
  #     admin.find_room
  #     admin.rooms[0].status.must_equal :unavailable
  #   end
  # end

  describe 'reserve room' do
    before do
      @admin = Hotel::Admin.new
      @start_date = Date.parse('2018-04-01')
      @end_date = Date.parse('2018-04-05')
    end
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
      res_one.room.room_number.wont_equal res_two.room.room_number
    end

    it 'allows a room reservation to start on the same day another reservation ends' do
      @admin.reserve_room(@start_date, @end_date).room.room_number.must_equal 1
      @admin.reserve_room(@end_date, @end_date + 1).room.room_number.must_equal 1
    end
  end

  describe 'find_reservations' do
    before do
      @admin = Hotel::Admin.new
    end
    it 'returns an array of reservations' do
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      @admin.find_reservations(start_date).must_be_instance_of Array

      @admin.find_reservations(start_date).length.must_equal 0

      @admin.reserve_room(start_date, end_date)

      @admin.find_reservations(start_date)[0].must_be_instance_of Hotel::Reservation

      @admin.find_reservations(start_date).length.must_equal 1

    end

    it 'chooses an available room and changes status to unavailable' do
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      @admin = Hotel::Admin.new
      @admin.rooms[0].status.must_equal :available
      @admin.reserve_room(start_date, end_date)
      @admin.rooms[0].status.must_equal :unavailable
    end
  end

  describe 'reservation cost' do
    it 'returns the cost of the reservation' do
      admin = Hotel::Admin.new
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      reservation = admin.reserve_room(start_date, end_date)
      admin.reservation_cost(reservation).must_equal 800.00
    end

    it 'throws an error if the reservation does not exist' do
      admin = Hotel::Admin.new

      proc {
        admin.reservation_cost()
      }.must_raise ArgumentError

      proc {
        admin.reservation_cost('reservation')
      }.must_raise ArgumentError

    end
  end

  describe 'available rooms' do
    before do
      @admin = Hotel::Admin.new
      @start_date = Date.parse('2018-04-01')
      @end_date = Date.parse('2018-04-05')
      @room_array = @admin.available_rooms(@start_date, @end_date)
    end

    it 'returns an array of available rooms' do
      @room_array.must_be_kind_of Array
      @room_array[0].must_be_instance_of Hotel::Room
      @room_array[0].status.must_equal :available
    end

    it 'raises an error if there are no available rooms' do
      proc { 21.times do
        @admin.reserve_room(@start_date, @end_date)
      end }.must_raise ArgumentError
    end

  end
end
