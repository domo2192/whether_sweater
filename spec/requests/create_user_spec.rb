require 'rails_helper'

RSpec.describe 'Users Request' do
  it "can create a new user" do
      @user = {
        "email": "whatever@example.com",
        "password": "password",
        "password_confirmation": "password"
      }

    headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    post "/api/v1/users", headers: headers, params: @user.to_json
    expect(response).to be_successful
    expect(response.status).to eq(201)

    expect(User.last.email).to eq(@user[:email])

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


  it 'will not create users when you have the same emails' do
    user1 = User.create(email: "whatever@example.com", password: "password", password_confirmation: "password", api_key: SecureRandom.base58(24))
    @user2 = {
      "email": "whatever@example.com",
      "password": "password",
      "password_confirmation": "password"
    }
    headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    post "/api/v1/users", headers: headers, params: @user2.to_json
    expect(response.status).to eq(400)
    bad_user = JSON.parse(response.body, symbolize_names: true)
    expect(bad_user).to be_a(Hash)
    expect(bad_user[:error]).to be_a(String)
    expect(bad_user[:error]).to eq("Validation failed: Email has already been taken")

  end

  it 'will not create users when they do not have matching passwords' do
    @user2 = {
      "email": "whatever@example.com",
      "password": "password",
      "password_confirmation": "password22"
      }
    headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    post "/api/v1/users", headers: headers, params: @user2.to_json
    expect(response.status).to eq(400)
    bad_user = JSON.parse(response.body, symbolize_names: true)
    expect(bad_user).to be_a(Hash)
    expect(bad_user[:error]).to be_a(String)
    expect(bad_user[:error]).to eq("Validation failed: Password confirmation doesn't match Password, Password confirmation doesn't match Password")
  end

  it 'will not create users if fields are missing' do
    @user2 = {
      "email": "whatever@example.com",
      "password_confirmation": "password22"
      }
    headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    post "/api/v1/users", headers: headers, params: @user2.to_json
    expect(response.status).to eq(400)
    bad_user = JSON.parse(response.body, symbolize_names: true)
    expect(bad_user).to be_a(Hash)
    expect(bad_user[:error]).to be_a(String)
    expect(bad_user[:error]).to eq("Validation failed: Password confirmation doesn't match Password, Password can't be blank, Password can't be blank")
  end

  it 'will not create users if fields are missing' do
    @user2 = {
      "password": "password22",
      "password_confirmation": "password22"
      }
    headers = {"CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json"}
    post "/api/v1/users", headers: headers, params: @user2.to_json
    expect(response.status).to eq(400)
    bad_user = JSON.parse(response.body, symbolize_names: true)
    expect(bad_user).to be_a(Hash)
    expect(bad_user[:error]).to be_a(String)
    expect(bad_user[:error]).to eq("Validation failed: Email can't be blank, Email is invalid")
  end
end
