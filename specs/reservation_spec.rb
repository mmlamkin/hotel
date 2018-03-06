require_relative 'spec_helper'

describe 'Reservation Class' do

  describe 'initialize' do
    before do
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      @room = Hotel::Room.new(1)
      @reservation = Hotel::Reservation.new(start_date, end_date, @room)
    end

    it 'has a date range' do
      @reservation.dates.must_be_kind_of Array
      @reservation.dates[0].must_be_instance_of Date
      @reservation.dates.length.must_equal 5
    end

    it 'has an assigned room' do
      @reservation.room.must_be_instance_of Hotel::Room
    end

    it 'returns an error for invalid dates' do

      proc {
        Hotel::Reservation.new('2018-04-01', Date.parse('2018-04-05'), @room)
      }.must_raise ArgumentError

      proc {
        Hotel::Reservation.new(Date.parse('2018-04-05'), Date.parse('2018-04-01'), @room)
      }.must_raise ArgumentError

      proc {
        Hotel::Reservation.new(Date.parse('2018-02-05'), Date.parse('2018-04-05'), @room)
      }.must_raise ArgumentError
    end
  end

  describe 'stay total' do
    before do
      start_date = Date.parse('2018-04-01')
      end_date = Date.parse('2018-04-05')
      room = Hotel::Room.new(1)
      @reservation = Hotel::Reservation.new(start_date, end_date, room)
    end

    it 'totals the cost of the reservation' do
      @reservation.cost.must_be_kind_of Float
      @reservation.cost.must_equal 800.00
    end
  end
end
