class WeatherFacade

  def self.get_forecast(location)
    get_coordinates = MapService.get_coordinates(location)
    coordinates = get_coordinates[:results][0][:locations][0][:latLng]
    forecast = ForecastService.get_forecast(coordinates[:lat], coordinates[:lng])
    objectify_forecast(forecast)
  end

  def self.objectify_forecast(forecast)
    OpenStruct.new({  })
  end
end
