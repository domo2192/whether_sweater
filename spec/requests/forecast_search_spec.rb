require 'rails_helper'

RSpec.describe 'Forecast Search'do
  describe 'happy path' do
    it 'returns the forcase for a given city' do
       get '/api/v1/forecast?location=denver,co'
       expect(response.status).to eq(200)
       data = JSON.parse(response.body, symbolize_names: true)
       expect(data).to be_a(Hash)
       check_hash_structure(data, :data, Hash)
       expect(data[:data].keys).to match_array(%i[id type attributes])
       check_hash_structure(data[:data], :id, NilClass)
       check_hash_structure(data[:data], :type, String)
       expect(data[:data][:type]).to eq('forecast')
       check_hash_structure(data[:data], :attributes, Hash)
       expect(data[:data][:attributes].keys).to match_array(%i[current_weather daily_weather hourly_weather])

       attributes = data[:data][:attributes]
    end
  end
end
