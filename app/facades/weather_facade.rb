class WeatherFacade

  def self.get_forecast(location)
    get_coordinates = MapService.get_coordinates(location)
    coordinates = get_coordinates[:results][0][:locations][0][:latLng]
    forecast = ForecastService.get_forecast(coordinates[:lat], coordinates[:lng])
    objectify_forecast(forecast)
  end

  def self.objectify_forecast(forecast)
    OpenStruct.new({ current_weather: objectify_current_forecast(forecast[:current]),
                     daily_weather:   objectify_daily_forecast(forecast[:daily]),
                     hourly_weather:  objectify_hourly_forecast(forecast[:hourly])
                  })
  end

  def self.objectify_current_forecast(current_forecast)
    OpenStruct.new({  datetime:      clean_time(current_forecast[:dt]),
                       sunrise:      clean_time(current_forecast[:sunrise]),
                       sunset:       clean_time(current_forecast[:sunset]),
                       temperature:  current_forecast[:temp],
                       feels_like:   current_forecast[:feels_like],
                       humidity:     current_forecast[:humidity],
                       uvi:          current_forecast[:uvi],
                       visibility:   current_forecast[:visibility],
                       conditions:   current_forecast[:weather][0][:description],
                       icon:         current_forecast[:weather][0][:icon]
                  })
  end

  def self.objectify_daily_forecast(daily_forecast)
    daily_forecast.map do |daily|
      daily_object(daily)
    end.first(5)
  end


  def self.daily_object(daily)
    OpenStruct.new({ date:       clean_day(daily[:dt]),
                     sunrise:    clean_time(daily[:sunrise]),
                     sunset:     clean_time(daily[:sunset]),
                     max_temp:   daily[:temp][:max],
                     min_temp:   daily[:temp][:min],
                     conditions: daily[:weather][0][:description],
                     icon:       daily[:weather][0][:icon]
                  })

  end

  def self.objectify_hourly_forecast(hourly_forecast)
    hourly_forecast.map do |hour|
      hour_object(hour)
    end.first(8)
  end

  def self.hour_object(hour)
    OpenStruct.new({ time:        clean_hour(hour[:dt]),
                     temperature: hour[:temp],
                     conditions:  hour[:weather][0][:description],
                     icon:        hour[:weather][0][:icon]
                  })
  end

  def self.clean_time(time)
    Time.at(time).strftime("%F %T %z")
  end

  def self.clean_hour(hour)
    Time.at(hour).strftime("%T")
  end

  def self.clean_day(daily)
    Time.at(daily).strftime("%F")
  end
end
