require 'rails_helper'

RSpec.describe 'Salary Facade' do
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
    expect(WeatherFacade.objectify_current_forecast(current_params)[:temperature]).to eq(62.85)
    expect(WeatherFacade.objectify_current_forecast(current_params)[:conditions]).to eq("overcast clouds")
  end
end
