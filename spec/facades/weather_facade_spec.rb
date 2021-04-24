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

    it 'returns an hour object' do
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
  end
end
