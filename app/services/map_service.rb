class MapService

  def self.get_coordinates(location)
    response = Faraday.get('https://www.mapquestapi.com/geocoding/v1/address') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params['key'] = 'JEhEx6kKF90oVbT6xIjpeMD3WoNVXCrz'
      req.params['location'] = location
    end
    JSON.parse(response.body, symbolize_names: true)
  end
end
