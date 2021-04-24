require 'rails_helper'

RSpec.describe 'Find background image'do
  describe 'happy path' do
    it 'returns a url for the specific city passed in' do
      get '/api/v1/backgrounds?location=denver,co'
      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to be_a(Hash)
      expect(data[:data]).to be_a(Hash)
      expect(data[:data].keys).to match_array(%i[type id attributes])
      expect(data[:data][:attributes].keys).to match_array(%i[image])
      expect(data[:data][:attributes][:image].keys).to match_array(%i[location image_url credit])
      expect(data[:data][:attributes][:image][:credit].keys).to match_array(%i[source author logo])
    end
  end
end
