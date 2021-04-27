require 'rails_helper'

RSpec.describe 'Background Facade' do
  describe 'unit tests' do
    it 'returns a credit hash' do
      location = 'Denver, Co'
      data = {:page=>1,
              :per_page=>1,
                :photos=>
                [{:id=>7429461,
                  :width=>5950,
                  :height=>3967,
                  :url=>"https://www.pexels.com/photo/people-in-a-meeting-7429461/",
                  :photographer=>"Ron Lach",
                  :photographer_url=>"https://www.pexels.com/@ron-lach",
                  :photographer_id=>22992178,
                  :avg_color=>"#A2A49A",
                  :src=>
                 {:original=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg",
                  :large2x=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&dpr=2&h=650&w=940",
                  :large=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&h=650&w=940",
                  :medium=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&h=350",
                  :small=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&h=130",
                  :portrait=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800",
                  :landscape=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=627&w=1200",
                  :tiny=>"https://images.pexels.com/photos/7429461/pexels-photo-7429461.jpeg?auto=compress&cs=tinysrgb&dpr=1&fit=crop&h=200&w=280"},
                  :liked=>false}],
                  :total_results=>1879,
                  :next_page=>"https://api.pexels.com/v1/search/?page=2&per_page=1&query=Denver%2C+Co"}
        test = BackgroundFacade.credit_hash(data[:photos][0])
       expect(test).to be_a(Hash)
       expect(test.keys).to match_array(%i[source author author_url])
       expect(test[:source]).to be_a(String)
       expect(test[:author]).to be_a(String)
       expect(test[:author_url]).to be_a(String)
    end

    it 'returns the correct format for objectify background' do
      VCR.use_cassette("hot_lanta_test_object") do 
        location = 'Atlanta, Ge'
        background = PixelService.get_image(location)
        test = BackgroundFacade.objectify_background(background, location)
        expect(test).to be_a(OpenStruct)
        expect(test.location).to be_a(String)
        expect(test.image_url).to be_a(String)
        expect(test.credit).to be_a(Hash)
        expect(test.credit[:source]).to be_a(String)
        expect(test.credit[:author]).to be_a(String)
        expect(test.credit[:author_url]).to be_a(String)
      end
    end
  end
end
