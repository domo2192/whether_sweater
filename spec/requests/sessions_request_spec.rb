require 'rails_helper'

RSpec.describe 'Sessions Request' do
  describe 'happy path' do
    it "can log in a new user" do
      user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
      @user = {
        "email": "whatever@example.com",
        "password": "password"
      }
      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      post "/api/v1/sessions", headers: headers, params: @user.to_json
      expect(response).to be_successful
      expect(response.status).to eq(200)
      user = JSON.parse(response.body, symbolize_names: true)
      expect(user).to have_key(:data)
      expect(user[:data]).to be_a(Hash)
      expect(user[:data]).to have_key(:type)
      expect(user[:data]).to have_key(:id)
      expect(user[:data]).to have_key(:attributes)
      expect(user[:data][:type]).to eq("users")
      expect(user[:data][:attributes]).to be_a(Hash)
      expect(user[:data][:attributes].keys).to match_array([:email, :api_key])
      expect(user[:data][:attributes][:email]).to be_a(String)
      expect(user[:data][:attributes][:email]).to eq(@user[:email])
      expect(user[:data][:attributes][:api_key]).to be_a(String)
    end

  end

  describe 'sad path' do
    it 'returns errors if no users have been created' do
      @user = {
        "email": "whatever@example.com",
        "password": "password"
      }
      headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
      post "/api/v1/sessions", headers: headers, params: @user.to_json
      expect(response.status).to eq(400)
      bad_user = JSON.parse(response.body, symbolize_names: true)
      expect(bad_user).to be_a(Hash)
      expect(bad_user[:error]).to be_a(String)
      expect(bad_user[:error]).to eq("Your credentials are bad!! Fix it!")
    end

  end
end
