require 'rails_helper'

RSpec.describe 'Find background image'do
  describe 'happy path' do
    it 'returns a url for the specific city passed in' do
      VCR.use_cassette('grab_denver_image') do
        get '/api/v1/backgrounds?location=denver,co'
        expect(response.status).to eq(200)
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data).to be_a(Hash)
        expect(data[:data]).to be_a(Hash)
        expect(data[:data][:type]).to eq(("image"))
        expect(data[:data].keys).to match_array(%i[type id attributes])
        expect(data[:data][:attributes].keys).to match_array(%i[location image_url credit])
        expect(data[:data][:attributes][:credit].keys).to match_array(%i[source author author_url])
        expect(data[:data][:attributes][:location]).to be_a(String)
        expect(data[:data][:attributes][:image_url]).to be_a(String)
        expect(data[:data][:attributes][:credit]).to be_a(Hash)
        expect(data[:data][:attributes][:credit][:source]).to be_a(String)
        expect(data[:data][:attributes][:credit][:author]).to be_a(String)
        expect(data[:data][:attributes][:credit][:author_url]).to be_a(String)
      end
    end
  end

  describe 'sad path' do
    it 'returns a error if no location is passed in' do
      VCR.use_cassette('bad_location') do
        get '/api/v1/backgrounds'
        expect(response.status).to eq(400)
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data).to be_a(Hash)
        expect(data[:message]).to eq("Your parameters are Invalid")
      end
    end

    it 'returns an for blank location' do
      VCR.use_cassette('bad_location_pictures') do
        get '/api/v1/backgrounds?location='
        expect(response.status).to eq(400)
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data).to be_a(Hash)
        expect(data[:message]).to eq("Your parameters are Invalid")
      end
    end

    it 'catches garbage' do
      VCR.use_cassette('bad_location_garbage') do
        get '/api/v1/backgrounds?location=jdfkj3ioj4io3jr'
        expect(response.status).to eq(200)
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data).to be_a(Hash)
        expect(data[:data]).to be_a(Hash)
        expect(data[:data][:attributes]).to be_a(Hash)
        expect(data[:data][:attributes][:image_url]).to eq("No images match that location")
        expect(data[:data][:attributes][:credit]).to eq("Nobody took no pictures of that!!!")
      end
    end
  end
end
