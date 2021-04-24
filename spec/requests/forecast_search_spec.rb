require 'rails_helper'

RSpec.describe 'Forecast Search'do
  describe 'happy path' do
    it 'returns the forcase for a given city' do
       get '/api/v1/forecast?location=denver,co'
       expect(response.status).to eq(200)
       data = JSON.parse(response.body, symbolize_names: true)
    end
  end
end
