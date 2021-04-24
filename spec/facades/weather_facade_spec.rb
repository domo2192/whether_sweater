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
  end
end
