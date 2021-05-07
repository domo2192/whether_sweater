require 'rails_helper'

RSpec.describe 'Weather Facade' do
  describe 'unit tests' do
    it 'cleans time to the expected format' do
      seconds = 1619290108
      date_time = "2021-04-24 18:48:28 +0000"
      expect(WeatherFacade.clean_time(seconds)).to eq(date_time)
    end

    it 'cleans hours to the expected format' do
      seconds =  1619294400
      hour_time = "20:00:00"
      expect(WeatherFacade.clean_hour(seconds)).to eq(hour_time)
    end

    it 'cleans day to the proper format' do
      seconds = 1619287200
      day_time = "2021-04-24"
      expect(WeatherFacade.clean_day(seconds)).to eq(day_time)
    end

    it 'hour object returns an hour object' do
      hour_params = {:dt=>1619294400,
                     :temp=>61.7,
                     :feels_like=>59.45,
                     :pressure=>1007,
                     :humidity=>40,
                     :dew_point=>37.17,
                     :uvi=>5.91,
                     :clouds=>100,
                     :visibility=>10000,
                     :wind_speed=>2.55,
                     :wind_deg=>6,
                     :wind_gust=>3.8,
                     :weather=>[{:id=>804, :main=>"Clouds", :description=>"overcast clouds", :icon=>"04d"}],
                     :pop=>0}

      expect(WeatherFacade.hour_object(hour_params).class).to eq(Hash)
      expect(WeatherFacade.hour_object(hour_params)[:time]).to eq("20:00:00")
      expect(WeatherFacade.hour_object(hour_params)[:temperature]).to eq(61.7)
      expect(WeatherFacade.hour_object(hour_params)[:conditions]).to eq("overcast clouds")
      expect(WeatherFacade.hour_object(hour_params)[:icon]).to eq("04d")
    end

    it 'daily object returns a daily object' do
      daily_params = { :dt=>1619287200,
                       :sunrise=>1619266137,
                       :sunset=>1619315203,
                       :moonrise=>1619305320,
                       :moonset=>1619262300,
                       :moon_phase=>0.41,
                       :temp=>{:day=>59.88, :min=>38.21, :max=>64, :night=>54.52, :eve=>64, :morn=>38.21},
                       :feels_like=>{:day=>56.98, :night=>38.21, :eve=>61.32, :morn=>38.21},
                       :pressure=>1008,
                       :humidity=>30,
                       :dew_point=>28.83,
                       :wind_speed=>6.87,
                       :wind_deg=>68,
                       :wind_gust=>8.63,
                       :weather=>[{:id=>803, :main=>"Clouds", :description=>"broken clouds", :icon=>"04d"}],
                       :clouds=>69,
                       :pop=>0,
                       :uvi=>6.7}
      expect(WeatherFacade.daily_object(daily_params).class).to eq(Hash)
      expect(WeatherFacade.daily_object(daily_params)[:date]).to eq("2021-04-24")
      expect(WeatherFacade.daily_object(daily_params)[:sunrise]).to eq("2021-04-24 07:08:57 +0000")
      expect(WeatherFacade.daily_object(daily_params)[:sunset]).to eq("2021-04-24 20:46:43 +0000")
      expect(WeatherFacade.daily_object(daily_params)[:max_temp]).to eq(64)
      expect(WeatherFacade.daily_object(daily_params)[:min_temp]).to eq(38.21)
      expect(WeatherFacade.daily_object(daily_params)[:conditions]).to eq("broken clouds")
      expect(WeatherFacade.daily_object(daily_params)[:icon]).to eq("04d")

    end

    it "current forcast returns a object with correct attributes" do
      current_params = { :dt=>1619297567,
                         :sunrise=>1619266137,
                         :sunset=>1619315203,
                         :temp=>62.85,
                         :feels_like=>60.48,
                         :pressure=>1006,
                         :humidity=>35,
                         :dew_point=>34.83,
                         :uvi=>4.71,
                         :clouds=>100,
                         :visibility=>10000,
                         :wind_speed=>1.01,
                         :wind_deg=>36,
                         :wind_gust=>7,
                         :weather=>[{:id=>804, :main=>"Clouds", :description=>"overcast clouds", :icon=>"04d"}]}
      expect(WeatherFacade.objectify_current_forecast(current_params).class).to eq(Hash)
      expect(WeatherFacade.objectify_current_forecast(current_params)[:datetime]).to eq("2021-04-24 15:52:47 +0000")
      expect(WeatherFacade.objectify_current_forecast(current_params)[:sunrise]).to eq("2021-04-24 07:08:57 +0000")
      expect(WeatherFacade.objectify_current_forecast(current_params)[:sunset]).to eq("2021-04-24 20:46:43 +0000")
      expect(WeatherFacade.objectify_current_forecast(current_params)[:temperature]).to eq(62.85)
      expect(WeatherFacade.objectify_current_forecast(current_params)[:feels_like]).to eq(60.48)
      expect(WeatherFacade.objectify_current_forecast(current_params)[:humidity]).to eq(35)
      expect(WeatherFacade.objectify_current_forecast(current_params)[:uvi]).to eq(4.71)
      expect(WeatherFacade.objectify_current_forecast(current_params)[:visibility]).to eq(10000)
      expect(WeatherFacade.objectify_current_forecast(current_params)[:conditions]).to eq("overcast clouds")
      expect(WeatherFacade.objectify_current_forecast(current_params)[:icon]).to eq("04d")
    end
  end

  describe 'unit tests' do
    it 'returns the expected amount of data' do
      VCR.use_cassette('full_forecast_colorado') do
        full_forecast = WeatherFacade.get_forecast('denver,co')
        expect(full_forecast.daily_weather.count).to eq(5)
        expect(full_forecast.hourly_weather.count).to eq(8)
      end
    end
  end
end
