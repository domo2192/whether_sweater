require 'rails_helper'

RSpec.describe 'Weather Facade' do
  describe 'unit tests' do
    it 'cleans time to the expected format' do
      seconds = 1619290108
      date_time = "2021-04-24 12:48:28 -0600"
      expect(WeatherFacade.clean_time(seconds)).to eq(date_time)
    end

    it 'cleans hours to the expected format' do
      seconds =  1619294400
      hour_time = "14:00:00"
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
      expect(WeatherFacade.hour_object(hour_params).class).to eq(OpenStruct)
      expect(WeatherFacade.hour_object(hour_params).time).to eq("14:00:00")
      expect(WeatherFacade.hour_object(hour_params).temperature).to eq(61.7)
      expect(WeatherFacade.hour_object(hour_params).conditions).to eq("overcast clouds")
      expect(WeatherFacade.hour_object(hour_params).icon).to eq("04d")
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
      expect(WeatherFacade.daily_object(daily_params).class).to eq(OpenStruct)
      expect(WeatherFacade.daily_object(daily_params).date).to eq("2021-04-24")
      expect(WeatherFacade.daily_object(daily_params).sunrise).to eq("2021-04-24 06:08:57 -0600")
      expect(WeatherFacade.daily_object(daily_params).sunset).to eq("2021-04-24 19:46:43 -0600")
      expect(WeatherFacade.daily_object(daily_params).max_temp).to eq(64)
      expect(WeatherFacade.daily_object(daily_params).min_temp).to eq(38.21)
      expect(WeatherFacade.daily_object(daily_params).conditions).to eq("broken clouds")
      expect(WeatherFacade.daily_object(daily_params).icon).to eq("04d")

    end
  end
end
