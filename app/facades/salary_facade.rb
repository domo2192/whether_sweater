class SalaryFacade

  def self.get_salaries(destination)
    salaries = SalaryService.get_cities(destination)
    get_coordinates = MapService.get_coordinates(destination)
    coordinates = get_coordinates[:results][0][:locations][0][:latLng]
    forecast = ForecastService.get_forecast(coordinates[:lat], coordinates[:lng])
    objectify_data(forecast, salaries)
  end

  def self.objectify_data(forecast, salaries)
    OpenStruct.new({ destination: objectify_current_forecast(forecast[:current]),
                      salaries:   objectify_salaries(salaries)
                   })
  end

  def self.objectify_current_forecast(current_forecast)
                  {     temperature:  current_forecast[:temp],
                      conditions:   current_forecast[:weather][0][:description]
                  }
  end

  def self.objectify_salaries(salaries)
    require "pry"; binding.pry
  #   {     title:  salaries[:],
  #       conditions:   current_forecast[:weather][0][:description]
  #   }
  end
end
