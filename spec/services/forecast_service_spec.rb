require 'rails_helper'

RSpec.describe "Weather Search" do
  describe "returns the current weather from OpenWeather One Call API when given coordinal location" do
    it 'returns happy' do
      VCR.use_cassette("current_weather") do
        lat = 39.738453
         lng =  -104.984853
        forecast = ForecastService.get_forecast(lat, lng)
        expect(forecast).to be_a Hash
        expect(forecast.keys).to match_array(%i[lat lon timezone timezone_offset current daily hourly])
        expect(forecast.keys.count).to eq(7)
        current = forecast[:current]

        expect(current).to be_a Hash
        expect(current.keys).to match_array(%i[clouds dew_point dt wind_deg wind_gust wind_speed sunrise sunset temp feels_like pressure humidity uvi visibility weather])
        expect(current[:dt]).to be_a Integer
        expect(current[:sunrise]).to be_a Integer
        expect(current[:sunset]).to be_a Integer
        expect(current[:temp]).to be_a Float
        expect(current[:feels_like]).to be_a Float
        expect(current[:pressure]).to be_a Integer
        expect(current[:humidity]).to be_a Integer
        expect(current[:uvi]).to be_a Numeric
        expect(current[:visibility]).to be_a Numeric
        expect(current[:weather]).to be_an Array
        expect(current[:weather][0]).to be_a Hash
        expect(current[:weather][0]).to be_a Hash
        expect(current[:weather][0].keys).to match_array(%i[main description id icon])
        expect(current[:weather][0][:main]).to be_a String
        expect(current[:weather][0][:description]).to be_a String
        expect(current[:weather][0][:icon]).to be_a String

        daily = forecast[:daily]
        expect(daily).to be_an Array
        day_1 = forecast[:daily].first
        expect(day_1).to be_a Hash
        expect(day_1.keys).to match_array(%i[clouds dew_point dt wind_deg wind_gust wind_speed sunrise sunset temp feels_like pressure humidity uvi weather moon_phase moonrise moonset pop])
        expect(day_1[:dt]).to be_a Integer
        expect(day_1[:sunrise]).to be_a Integer
        expect(day_1[:sunset]).to be_a Integer
        expect(day_1[:moonrise]).to be_a Integer
        expect(day_1[:moonset]).to be_a Integer
        expect(day_1[:pressure]).to be_a Numeric
        expect(day_1[:humidity]).to be_a Numeric
        expect(day_1[:uvi]).to be_a Numeric
        expect(day_1[:temp]).to be_a Hash
        expect(day_1[:temp].keys).to match_array(%i[min max day eve morn night])
        expect(day_1[:temp][:min]).to be_a Numeric
        expect(day_1[:temp][:max]).to be_a Numeric
        expect(day_1).to have_key(:weather)
        expect(day_1[:weather]).to be_an Array
        expect(day_1[:weather][0]).to be_a Hash
        expect(day_1[:weather][0].keys).to match_array(%i[main description icon id])
        expect(day_1[:weather][0][:description]).to be_a String
        expect(day_1[:weather][0][:icon]).to be_a String


        hourly = forecast[:hourly]
        expect(hourly).to be_an Array
        hour_1 = forecast[:hourly][0]

        expect(hour_1).to be_a Hash
        expect(hour_1.keys).to match_array(%i[clouds dew_point dt wind_deg wind_gust wind_speed temp feels_like pressure humidity uvi weather pop visibility])
        expect(hour_1[:dt]).to be_a Integer
        expect(hour_1[:temp]).to be_a Float
        expect(hour_1[:feels_like]).to be_a Float
        expect(hour_1[:pressure]).to be_a Integer
        expect(hour_1[:humidity]).to be_a Integer
        expect(hour_1[:uvi]).to be_a Float
        expect(hour_1[:visibility]).to be_a Numeric
        expect(hour_1[:weather]).to be_an Array
        expect(hour_1[:weather][0]).to be_a Hash
        expect(hour_1[:weather][0].keys).to match_array(%i[main icon description id])
        expect(hour_1[:weather][0][:main]).to be_a String
        expect(hour_1[:weather][0][:description]).to be_a String
        expect(hour_1[:weather][0][:icon]).to be_a String
      end
    end
  end

  describe 'sad path' do
    it 'returns a different response if you pass in an empty string' do
      VCR.use_cassette("bad_service_empty") do
        lat = 39.738453
        lng =  ''
        forecast = ForecastService.get_forecast(lat, lng)
        expect(forecast).to be_a(Hash)
        expect(forecast[:message]).to eq("Nothing to geocode")
      end
    end

    it 'breaks if you pass in a string' do
      VCR.use_cassette("bad_service_string") do
        lat = 39.738453
        lng =  'thirtynine'
        forecast = ForecastService.get_forecast(lat, lng)
        expect(forecast).to be_a(Hash)
        expect(forecast[:message]).to eq("Nothing to geocode")
      end
    end
  end
end
