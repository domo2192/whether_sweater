class RoadtripFacade

  def self.get_roadtrip(origin, destination)
    directions = MapService.get_directions(origin, destination)
    if !directions[:info][:messages].empty?
      check_route(directions, origin, destination)
    else
    get_coordinates = MapService.get_coordinates(destination)
    coordinates = get_coordinates[:results][0][:locations][0][:latLng]
    forecast = ForecastService.hourly_forecast(coordinates[:lat], coordinates[:lng])
    objectify_data(origin, destination, directions, forecast )
    end
  end


  def self.objectify_data(origin, destination, directions, forecast)
    OpenStruct.new({  start_city: origin,
                      end_city: destination,
                      travel_time: clean_time(directions[:route][:realTime]),
                      weather_at_eta: hash_weather_data(forecast, directions[:route][:realTime])
                   })
  end

  def self.clean_time(epoch_time)
    hours = epoch_time/ 3600
    minutes = (epoch_time/60 - hours*60)
    return ("#{hours}" " " "hours" "," " and " "#{minutes}"  " "  "minutes")
  end

  def self.hash_weather_data(forecast, epoch_time)
     arrival_time = epoch_time + Time.now.to_i
     eta_weather = forecast[:hourly].find_all do |hour|
       arrival_time > hour[:dt]
    end.last
    {temperature: eta_weather[:temp], conditions: eta_weather[:weather][0][:description]}
  end

  def self.check_route(directions, origin, destination)
  OpenStruct.new ({  start_city: origin,
                    end_city: destination,
                    travel_time: directions[:info][:messages].pop ,
                    weather_at_eta: "You shouldn't care."})
  end
end
