class ForecastService

  def self.get_forecast(lat, lng)
    response = Faraday.get('https://api.openweathermap.org/data/2.5/onecall?') do |req|
      req.headers["CONTENT_TYPE"] = "application/json"
      req.params['appid'] = '618a4595b512d53e1ec40ec117d516fc'
      req.params['lat'] = lat
      req.params['lon'] = lng
      req.params['units'] = 'imperial'
    end
      JSON.parse(response.body, symbolize_names: true)
  end
end
