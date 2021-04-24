require 'rails_helper'

RSpec.describe 'Forecast Search'do
  describe 'happy path' do
    it 'returns the correct structure' do
      VCR.use_cassette("denver_forecast_happy") do
         get '/api/v1/forecast?location=denver,co'
         expect(response.status).to eq(200)
         data = JSON.parse(response.body, symbolize_names: true)
         expect(data).to be_a(Hash)
         expect(data[:data]).to be_a(Hash)
         expect(data[:data].keys).to match_array(%i[id type attributes])
         expect(data[:data]).to have_key(:id)
         expect(data[:data][:id]).to eq(nil)
         expect(data[:data][:type]).to eq("forecast")
         expect(data[:data][:attributes]).to be_a(Hash)
         expect(data[:data][:attributes].keys).to match_array(%i[current_weather daily_weather hourly_weather])
         expect(data[:data][:attributes][:current_weather]).to be_a(Hash)
         expect(data[:data][:attributes][:daily_weather]).to be_a(Array)
         expect(data[:data][:attributes][:hourly_weather]).to be_a(Array)
         expect(data[:data][:attributes][:current_weather].keys).to match_array(%i[datetime sunrise sunset temperature feels_like humidity uvi visibility conditions icon])
         expect(data[:data][:attributes][:current_weather][:datetime]).to be_a(String)
         expect(data[:data][:attributes][:current_weather][:sunrise]).to be_a(String)
         expect(data[:data][:attributes][:current_weather][:sunset]).to be_a(String)
         expect(data[:data][:attributes][:current_weather][:temperature]).to be_a(Float)
         expect(data[:data][:attributes][:current_weather][:feels_like]).to be_a(Float)
         expect(data[:data][:attributes][:current_weather][:humidity]).to be_a(Numeric)
         expect(data[:data][:attributes][:current_weather][:uvi]).to be_a(Numeric)
         expect(data[:data][:attributes][:current_weather][:visibility]).to be_a(Numeric)
         expect(data[:data][:attributes][:current_weather][:conditions]).to be_a(String)
         expect(data[:data][:attributes][:current_weather][:icon]).to be_a(String)
         data[:data][:attributes][:daily_weather].each do |day|
           expect(day.keys).to match_array(%i[date sunrise sunset max_temp min_temp conditions icon])
           expect(day[:date]).to be_a(String)
           expect(Time.parse(day[:date])).to be_a(Time)
           expect(day[:sunrise]).to be_a(String)
           expect(Time.parse(day[:sunrise])).to be_a(Time)
           expect(day[:sunset]).to be_a(String)
           expect(Time.parse(day[:sunset])).to be_a(Time)
           expect(day[:max_temp]).to be_a(Float)
           expect(day[:min_temp]).to be_a(Float)
           expect(day[:conditions]).to be_a(String)
           expect(day[:icon]).to be_a(String)
         end
         data[:data][:attributes][:hourly_weather].each do |day|
           expect(day.keys).to match_array(%i[time temperature conditions icon])
           expect(day[:time]).to be_a(String)
           expect(Time.parse(day[:time])).to be_a(Time)
           expect(day[:temperature]).to be_a(Numeric)
           expect(day[:conditions]).to be_a(String)
           expect(day[:icon]).to be_a(String)
         end

      end
    end

    it 'can return a different city' do
      VCR.use_cassette("chicago_forecast_happy") do
        get '/api/v1/forecast?location=chicago,il'
        expect(response.status).to eq(200)
        data = JSON.parse(response.body, symbolize_names: true)
        expect(data).to be_a(Hash)
        expect(data[:data]).to be_a(Hash)
        expect(data[:data].keys).to match_array(%i[id type attributes])
      end
    end
  end

  describe 'sad path' do
    it 'renders errors when no city is passed in' do
      VCR.use_cassette("no_city_sad") do
        get '/api/v1/forecast'
        expect(response.status).to eq(400)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to eq(message: "Your parameters are Invalid")
      end
    end

    it 'renders 400 if location is present but empty' do
      VCR.use_cassette("location_empty_sad") do
        get '/api/v1/forecast?location='
        expect(response.status).to eq(400)
        body = JSON.parse(response.body, symbolize_names: true)
        expect(body).to eq(message: "Your parameters are Invalid")
      end
    end
  end
end
