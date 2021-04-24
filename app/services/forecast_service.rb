class ForecastService

  def self.get_forecast(lat, lng)
    response = Faraday.get('https://api.openweathermap.org/data/2.5/onecall?') do |req|
      req.headers[:CONTENT_TYPE] = "application/json"
      req.params[:appid] = ENV['FORECAST_API_KEY']
      req.params[:lat] = lat
      req.params[:lon] = lng
      req.params[:units] = 'imperial'
      req.params[:exclude] = 'minutely,alerts'
    end
      JSON.parse(response.body, symbolize_names: true)
  end
end
