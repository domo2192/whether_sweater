class PixelService


  def self.get_image(location)
    response = Faraday.get('https://api.pexels.com/v1/search') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.headers['Authorization'] = ENV['PIXEL_API_KEY']
      req.params['query'] = location
      req.params['per_page'] = 1
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
