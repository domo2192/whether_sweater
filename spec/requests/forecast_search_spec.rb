require 'rails_helper'

RSpec.describe 'Forecast Search'do
  describe 'happy path' do
    it 'returns the forcase for a given city' do
       get '/api/v1/forecast?location=denver,co'
       expect(response.status).to eq(200)
       data = JSON.parse(response.body, symbolize_names: true)
       expect(data).to be_a(Hash)
       expect(data[:data]).to be_a(Hash)
       expect(data[:data].keys).to match_array(%i[id type attributes])
       expect(data[:data]).to have_key(:id)
       expect(data[:data][:id]).to eq(nil)
       expect(data[:data][:type]).to eq("forecast")
       expect(data[:data][:attributes]).to be_a(Hash)
       expect(data[:data][:attributes].keys).to match_array(%i[current_weather daily_weather hourly_weather])
       expect(data[:data][:attributes][:current_weather]).to be_a(Hash)
       expect(data[:data][:attributes][:current_weather].keys).to match_array(%i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions icon])

    end
  end
end
