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
    #
    # it 'has a hash of reservations' do
    #   @admin.reservations.must_be_instance_of Hash
    # end

    it 'has aan array of reservations' do
      @admin.reservations.must_be_instance_of Array
    end
  end

  describe 'find_room' do
    it 'returns an instance of room' do
      admin = Hotel::Admin.new
      admin.find_room.must_be_instance_of Hotel::Room
    end

    it 'returns an available room and changes status to unavailable' do
      admin = Hotel::Admin.new
      admin.rooms[0].status.must_equal :available
      admin.find_room
      admin.rooms[0].status.must_equal :unavailable
    end
  end

  describe 'reserve room' do
    before do
      @admin = Hotel::Admin.new
    end
    it 'creates an instance of Reservation' do
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      @admin.reserve_room(start_date, end_date).must_be_instance_of Hotel::Reservation
    end

    it 'adds reservation information to @reservations' do
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      @admin.reservations.length.must_equal 0
      @admin.reserve_room(start_date, end_date)
      @admin.reservations.length.must_equal 1
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

  end

end
