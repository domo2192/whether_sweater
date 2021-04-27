require 'rails_helper'

RSpec.describe 'Roadtrip Request' do
  describe 'happy path' do
    it 'returns the expected information' do
      VCR.use_cassette('grab_denver_to_pueblo') do
        user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
        params = {"origin": "Denver,CO",
                  "destination": "Pueblo,CO",
                   "api_key": "#{user1.api_key}"}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        post '/api/v1/road_trip', headers: headers, params: params.to_json
        expect(response).to be_successful
        expect(response.status).to eq(200)
        user = JSON.parse(response.body, symbolize_names: true)
        expect(user).to have_key(:data)
        expect(user[:data]).to be_a(Hash)
        expect(user[:data]).to have_key(:type)
        expect(user[:data]).to have_key(:id)
        expect(user[:data]).to have_key(:attributes)
        expect(user[:data][:type]).to eq("roadtrip")
        expect(user[:data][:attributes]).to be_a(Hash)
        expect(user[:data][:attributes].keys).to match_array([:start_city, :end_city, :travel_time, :weather_at_eta ])
        expect(user[:data][:attributes][:start_city]).to eq("Denver,CO")
        expect(user[:data][:attributes][:end_city]).to eq("Pueblo,CO")
        expect(user[:data][:attributes][:travel_time]).to eq("1 hours, and 51 minutes")
        expect(user[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(user[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Numeric)
        expect(user[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
      end
    end
  end

  describe 'sad path' do
    it 'breaks on unauthorized calls with no api key' do
      user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
      params = {"origin": "Denver,CO",
                "destination": "Pueblo,CO"}
      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      post '/api/v1/road_trip', headers: headers, params: params.to_json
      expect(response.status).to eq(401)
      bad_user = JSON.parse(response.body, symbolize_names: true)
      expect(bad_user).to be_a(Hash)
      expect(bad_user[:error]).to be_a(String)
      expect(bad_user[:error]).to eq("Unauthorized")
    end

    it 'breaks when a key is passed but it is the wrong one' do
      user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
      params = {"origin": "Denver,CO",
                "destination": "Pueblo,CO",
                 "api_key": "#{SecureRandom.base58(24)}"}
     post '/api/v1/road_trip', headers: headers, params: params.to_json
     expect(response.status).to eq(401)
     bad_user = JSON.parse(response.body, symbolize_names: true)
     expect(bad_user).to be_a(Hash)
     expect(bad_user[:error]).to be_a(String)
     expect(bad_user[:error]).to eq("Unauthorized")
    end
  end
end
