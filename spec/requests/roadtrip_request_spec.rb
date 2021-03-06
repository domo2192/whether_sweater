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
        expect(user[:data][:attributes][:travel_time]).to be_a(String)
        expect(user[:data][:attributes][:weather_at_eta]).to be_a(Hash)
        expect(user[:data][:attributes][:weather_at_eta][:temperature]).to be_a(Numeric)
        expect(user[:data][:attributes][:weather_at_eta][:conditions]).to be_a(String)
      end
    end
  end

  describe 'sad path' do
    it 'breaks on unauthorized calls with no api key' do
      VCR.use_cassette('no_api_sad_road') do
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
    end

    it 'breaks when a key is passed but it is the wrong one' do
      VCR.use_cassette('bad_api_sad_road') do
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

    it 'breaks when the origin or destination is not included' do
      VCR.use_cassette('no_destination_sad') do
        user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
        params = {"origin": "Denver,CO",
                   "api_key": "#{user1.api_key}"}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        post '/api/v1/road_trip', headers: headers, params: params.to_json
        expect(response.status).to eq(400)
        bad_locations = JSON.parse(response.body, symbolize_names: true)
        expect(bad_locations).to be_a(Hash)
        expect(bad_locations[:error]).to be_a(String)
        expect(bad_locations[:error]).to eq("You must pass an origin and destination.")
      end
    end

    it 'breaks when the path is empty' do
      VCR.use_cassette('empty_destination_sad') do
        user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
        params = {"origin": "Denver,CO",
                  "destination": "",
                   "api_key": "#{user1.api_key}"}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        post '/api/v1/road_trip', headers: headers, params: params.to_json
        expect(response.status).to eq(200)
        bad_location = JSON.parse(response.body, symbolize_names: true)
        expect(bad_location.class).to eq(Hash)
        expect(bad_location[:data].class).to be(Hash)
        expect(bad_location[:data][:attributes].keys).to match_array([:start_city, :end_city, :travel_time, :weather_at_eta ])
        expect(bad_location[:data][:attributes][:travel_time]).to eq("At least two locations must be provided.")
      end
    end

    it 'breaks when you pass in literal garbage' do
      VCR.use_cassette('garbage_destination_sad') do
        user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
        params = {"origin": "Denver,CO",
                  "destination": "kdjf;lkj3ou94uiojlkj",
                   "api_key": "#{user1.api_key}"}
        headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
        post '/api/v1/road_trip', headers: headers, params: params.to_json
        expect(response.status).to eq(200)
        bad_location = JSON.parse(response.body, symbolize_names: true)
        expect(bad_location.class).to eq(Hash)
        expect(bad_location[:data].class).to be(Hash)
        expect(bad_location[:data][:attributes].keys).to match_array([:start_city, :end_city, :travel_time, :weather_at_eta ])
        expect(bad_location[:data][:attributes][:travel_time]).to eq("Unable to calculate route.")
      end
    end
  end
end
