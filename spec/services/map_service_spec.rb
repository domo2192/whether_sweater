require 'rails_helper'

RSpec.describe "Weather Search" do
  describe "returns the map service" do
    it 'returns happy' do
      VCR.use_cassette('map_service') do
        location = 'denver, co'
        data = MapService.get_coordinates(location)
        expect(data).to be_a(Hash)
        expect(data.keys).to match_array([:info, :options, :results])
        expect(data[:results]).to be_an(Array)
      end
    end
  end

  describe 'sad path' do
    it 'returns sad' do
      VCR.use_cassette('map_service_bad') do
        location = ''
        data = MapService.get_coordinates(location)
        expect(data[:info][:messages]).to eq(["Illegal argument from request: Insufficient info for location"])
      end
    end
  end
end
