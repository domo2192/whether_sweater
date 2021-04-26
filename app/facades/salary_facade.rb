class SalaryFacade

  def self.get_salaries(destination)
    salaries = SalaryService.get_salaries(destination)
    get_coordinates = MapService.get_coordinates(destination)
    coordinates = get_coordinates[:results][0][:locations][0][:latLng]
    forecast = ForecastService.current_forecast(coordinates[:lat], coordinates[:lng])
    objectify_data(forecast, salaries)
  end

  def self.objectify_data(forecast, salaries)
    OpenStruct.new({ destination: objectify_current_forecast(forecast[:current])
                  #    salaries:   objectify_salries(salaries[:daily]),
                  #    hourly_weather:  objectify_hourly_forecast(forecast[:hourly])
                  # })
  end

  def self.objectify_current_forecast(current_forecast)
          {           temperature:  current_forecast[:temp],
                      conditions:   current_forecast[:weather][0][:description]
                  }
  end
end
