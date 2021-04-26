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
    expect(SalaryFacade.objectify_current_forecast(current_params).class).to eq(Hash)
    expect(SalaryFacade.objectify_current_forecast(current_params)[:temperature]).to eq(62.85)
    expect(SalaryFacade.objectify_current_forecast(current_params)[:conditions]).to eq("overcast clouds")
  end

  it 'returns the specific data we want' do
    test_data = {:_links=>
  {:curies=>
    [{:href=>"https://developers.teleport.org/api/resources/Location/#!/relations/{rel}/", :name=>"location", :templated=>true},
     {:href=>"https://developers.teleport.org/api/resources/City/#!/relations/{rel}/", :name=>"city", :templated=>true},
     {:href=>"https://developers.teleport.org/api/resources/UrbanArea/#!/relations/{rel}/", :name=>"ua", :templated=>true},
     {:href=>"https://developers.teleport.org/api/resources/Country/#!/relations/{rel}/", :name=>"country", :templated=>true},
     {:href=>"https://developers.teleport.org/api/resources/Admin1Division/#!/relations/{rel}/", :name=>"a1", :templated=>true},
     {:href=>"https://developers.teleport.org/api/resources/Timezone/#!/relations/{rel}/", :name=>"tz", :templated=>true}],
   :self=>{:href=>"https://api.teleport.org/api/urban_areas/slug:chicago/salaries/"}},
 :salaries=>
  [{:job=>{:id=>"CIVIL-ENGINEER", :title=>"Civil Engineer"}, :salary_percentiles=>{:percentile_25=>75046.79203102979, :percentile_50=>89467.74100530887, :percentile_75=>106659.81135187489}},
   {:job=>{:id=>"CONTENT-MARKETING", :title=>"Content Marketing"}, :salary_percentiles=>{:percentile_25=>39402.36738857876, :percentile_50=>49333.79507025396, :percentile_75=>61768.4544695476}},
   {:job=>{:id=>"COPYWRITER", :title=>"Copywriter"}, :salary_percentiles=>{:percentile_25=>37874.33329144154, :percentile_50=>46571.95367417419, :percentile_75=>57266.9319969137}},
   {:job=>{:id=>"CUSTOMER-SUPPORT", :title=>"Customer Support"}, :salary_percentiles=>{:percentile_25=>28709.782495494794, :percentile_50=>36911.39045392457, :percentile_75=>47455.97586661874}},
   {:job=>{:id=>"DATA-ANALYST", :title=>"Data Analyst"}, :salary_percentiles=>{:percentile_25=>46898.18614517015, :percentile_50=>56442.498784333024, :percentile_75=>67929.18726447425}},
   {:job=>{:id=>"DATA-SCIENTIST", :title=>"Data Scientist"}, :salary_percentiles=>{:percentile_25=>71025.60310363481, :percentile_50=>85799.94207526707, :percentile_75=>103647.55438088557}}]}
   expect(SalaryFacade.objectify_salaries(test_data).class).to eq(Array)
   expect(SalaryFacade.objectify_salaries(test_data)[0].keys).to match_array(%i[title min max])
   expect(SalaryFacade.objectify_salaries(test_data)[0][:title]).to eq("Data Analyst")
   expect(SalaryFacade.objectify_salaries(test_data)[0][:min]).to eq("$46,898.19")
   expect(SalaryFacade.objectify_salaries(test_data)[0][:max]).to eq("$67,929.19",)
  end
end
