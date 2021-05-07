require 'rails_helper'

RSpec.describe 'Salary Service' do
  describe "happy path " do
    it 'hits the connections expected' do
      VCR.use_cassette('salary_happy') do
      ua_id = "https://api.teleport.org/api/urban_areas/slug:denver/"
      result = SalaryService.find_salaries(ua_id)

      expect(result[:salaries]).to be_an(Array)
      expect(result[:salaries].count).to eq(52)
      result[:salaries].each do |row|

        expect(row[:job].keys).to match_array(%i[id title])
        expect(row[:salary_percentiles].keys).to match_array(%i[percentile_25 percentile_50 percentile_75])
        end
      end
    end
  end
end
