require 'rails_helper'

RSpec.describe "Pixel Search" do
  describe "returns the an image" do
    it 'returns happy' do
      VCR.use_cassette('pixel_happy_denver') do
        location = 'Denver, Co'
        test = PixelService.get_image(location)
        expect(test).to be_a(Hash)
        expect(test[:page]).to be_a(Numeric)
        expect(test[:photos]).to be_an(Array)
        expect(test[:photos][0]).to be_a(Hash)
        expect(test[:photos][0].keys).to match_array([:id, :width, :height, :url, :photographer, :photographer_url, :photographer_id, :avg_color, :src, :liked])
        expect(test[:photos][0][:src]).to be_a(Hash)
        expect(test[:photos][0][:src].keys).to match_array([:original, :large2x, :large, :medium, :small, :portrait, :landscape, :tiny])
      end
    end
  end

  describe 'sad path' do
    it 'is sad with bad locations' do
      VCR.use_cassette('pixel_sad_path') do
        location = ''
        test = PixelService.get_image(location)
        expect(test[:code]).to eq("No query param given")
      end
    end
  end
end
