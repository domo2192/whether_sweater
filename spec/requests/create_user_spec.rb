require 'rails_helper'

RSpec.describe 'Users Request' do
  it "can create a new user" do
      user = {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "password"
      }

    headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    post "/api/v1/users", headers: headers, params: user.to_json

    expect(response).to be_successful

    expect(created_user.email).to eq(user_params[:email])

    expect(response.status).to eq(201)
    user = JSON.parse(response.body, symbolize_names: true)
    expect(user).to have_key(:data)
    expect(user[:data]).to be_a Hash

    expect(user[:data]).to have_key(:type)
    expect(user[:data][:type]).to eq("users")

    expect(user[:data]).to have_key(:id)
    expect(user[:data]).to have_key(:attributes)
    expect(user[:data][:attributes]).to be_a Hash
    user1 = user[:data][:attributes]
    expect(user1.keys.count).to eq(2)
    expect(user1).to have_key(:email)
    expect(user1[:email]).to be_a String
    expect(user1).to have_key(:api_key)
    expect(user1[:api_key]).to be_a String
  end
end
