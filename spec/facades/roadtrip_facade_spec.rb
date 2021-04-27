require 'rails_helper'

RSpec.describe 'Roadtrip Facade' do
  describe 'unit tests' do
    it "can clean a epoch time and turn it into hours and minutes" do
      epoch_time = 8500
      new_time = RoadtripFacade.clean_time(epoch_time)
      expect(new_time).to eq('2 hours, and 21 minutes')
    end

    it 'cleans larger amounts of data' do
      epoch_time = 100000
      new_time = RoadtripFacade.clean_time(epoch_time)
      expect(new_time).to eq('27 hours, and 46 minutes')
    end

    it 'grabs the correct dt when you turn weather data into a hash' do
        VCR.use_cassette("roadtrip_data") do
        epoch_time = 900000
        coordinates = {:lat=>38.265425, :lng=>-104.610415}
        forecast = ForecastService.hourly_forecast(coordinates[:lat], coordinates[:lng])
        test = RoadtripFacade.hash_weather_data(forecast, epoch_time)
        expect(test.keys).to match_array(%i[temperature conditions])
        expect(test[:temperature]).to be_a(Numeric)
        expect(test[:conditions]).to be_a(String)
      end
    end

    it 'can openstruct expected data when given good endpoints' do
      VCR.use_cassette("objectify_data_test") do
        origin = 'Denver, Co'
        destination = 'Omaha, Ne'
        directions = MapService.get_directions(origin, destination)
        get_coordinates = MapService.get_coordinates(destination)
        coordinates = get_coordinates[:results][0][:locations][0][:latLng]
        forecast = ForecastService.hourly_forecast(coordinates[:lat], coordinates[:lng])
        test = RoadtripFacade.objectify_data(origin, destination, directions, forecast)
        expect(test.class).to be(OpenStruct)
        expect(test.start_city).to be_a(String)
        expect(test.end_city).to be_a(String)
        expect(test.travel_time).to be_a(String)
        expect(test.weather_at_eta).to be_a(Hash)
        expect(test.weather_at_eta[:temperature]).to be_a(Numeric)
        expect(test.weather_at_eta[:conditions]).to be_a(String)
      end
    end
  end

  describe 'unit test' do

    it 'returns openstructs' do
      VCR.use_cassette("unit_test_roadtrip") do
        origin = 'Miami, Fl'
        destination = 'Austin, Tx'
        test = RoadtripFacade.get_roadtrip(origin, destination)
        expect(test.class).to be(OpenStruct)
        expect(test.start_city).to be_a(String)
        expect(test.end_city).to be_a(String)
        expect(test.travel_time).to be_a(String)
        expect(test.weather_at_eta).to be_a(Hash)
        expect(test.weather_at_eta[:temperature]).to be_a(Numeric)
        expect(test.weather_at_eta[:conditions]).to be_a(String)
      end
    end
  end

  describe 'sad path' do
    it 'breaks if the path is impossible' do
      VCR.use_cassette("sad_path_impossible_trip") do
        origin = 'Miami, Fl'
        destination = 'Hamburg, Ge'
        test = RoadtripFacade.get_roadtrip(origin, destination)
        expect(test.start_city).to eq('Miami, Fl')
        expect(test.end_city).to eq('Hamburg, Ge')
        expect(test.travel_time).to eq("We are unable to route with the given locations.")
        expect(test.weather_at_eta).to be_a(Hash)
        expect(test.weather_at_eta[:conditions]).to eq("You shouldn't care.")
        expect(test.weather_at_eta[:temperature]).to eq(-1000)
      end
    end
  end
end
