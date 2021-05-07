require 'rails_helper'

RSpec.describe 'Salaries Request' do
  describe 'happy path' do
    it "can return salaries" do
      get '/api/v1/salaries?destination=chicago'
      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to be_a(Hash)
      expect(data[:data]).to be_a(Hash)
      expect(data[:data].keys).to match_array(%i[id type attributes])
      expect(data[:data][:id]).to eq(nil)
      expect(data[:data][:type]).to eq("salaries")
      expect(data[:data][:attributes]).to be_a(Hash)
      expect(data[:data][:attributes].keys).to match_array(%i[destination forecast salaries])
      expect(data[:data][:attributes][:destination]).to eq("chicago")
      expect(data[:data][:attributes][:forecast]).to be_a(Hash)
      expect(data[:data][:attributes][:forecast].keys).to match_array(%i[summary temperature])
      expect(data[:data][:attributes][:salaries]).to be_an(Array)
      expect(data[:data][:attributes][:salaries].count).to eq(7)
      data[:data][:attributes][:salaries].each do |title|
         expect(title.keys).to match_array(%i[title min max])
         expect(title[:title]).to be_a(String)
         expect(title[:min]).to be_a(String)
         expect(title[:max]).to be_a(String)
       end


    end

    it ' can return a different city' do
      get '/api/v1/salaries?destination=atlanta'
      expect(response.status).to eq(200)
      data = JSON.parse(response.body, symbolize_names: true)
      expect(data).to be_a(Hash)
      expect(data[:data]).to be_a(Hash)
      expect(data[:data].keys).to match_array(%i[id type attributes])
      expect(data[:data][:id]).to eq(nil)
      expect(data[:data][:type]).to eq("salaries")
      expect(data[:data][:attributes]).to be_a(Hash)
      expect(data[:data][:attributes].keys).to match_array(%i[destination forecast salaries])
      expect(data[:data][:attributes][:destination]).to eq("atlanta")
      expect(data[:data][:attributes][:forecast]).to be_a(Hash)
      expect(data[:data][:attributes][:forecast].keys).to match_array(%i[summary temperature])
      expect(data[:data][:attributes][:salaries]).to be_an(Array)
      expect(data[:data][:attributes][:salaries].count).to eq(7)
      data[:data][:attributes][:salaries].each do |title|
         expect(title.keys).to match_array(%i[title min max])
         expect(title[:title]).to be_a(String)
         expect(title[:min]).to be_a(String)
         expect(title[:max]).to be_a(String)
       end
    end
  end

  describe 'sad path' do
    it 'returns an error if location is not passed in' do
      get '/api/v1/salaries'
      expect(response.status).to eq(400)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eq(message: "Your parameters are Invalid")
    end

    it 'returns an error if location is blank' do
      get '/api/v1/salaries?location='
      expect(response.status).to eq(400)
      body = JSON.parse(response.body, symbolize_names: true)
      expect(body).to eq(message: "Your parameters are Invalid")
    end
  end
end
