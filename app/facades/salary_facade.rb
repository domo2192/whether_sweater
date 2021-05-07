class SalaryFacade

  def self.get_salaries(destination)
    salaries = SalaryService.get_cities(destination)
    get_coordinates = MapService.get_coordinates(destination)
    coordinates = get_coordinates[:results][0][:locations][0][:latLng]
    forecast = ForecastService.get_forecast(coordinates[:lat], coordinates[:lng])
    objectify_data(forecast, salaries, destination)
  end

  def self.objectify_data(forecast, salaries, destination)
    OpenStruct.new({  destination: destination,
                      forecast: objectify_current_forecast(forecast[:current]),
                      salaries:   objectify_salaries(salaries)
                   })
  end

  def self.objectify_current_forecast(current_forecast)
                  {     temperature:  current_forecast[:temp],
                        summary:   current_forecast[:weather][0][:description]
                  }
  end

  def self.objectify_salaries(salaries)
    tech_jobs = salaries[:salaries].find_all do |job|
      job[:job][:title] == "Data Analyst" ||   job[:job][:title] == "Data Scientist" ||
      job[:job][:title] == "Mobile Developer" || job[:job][:title] == "QA Engineer" ||
      job[:job][:title] == "Software Engineer" || job[:job][:title] == "Systems Administrator" || job[:job][:title] == "Web Developer"

    end
    tech_jobs.map do |job|
        {     title:  job[:job][:title],
                min:   number_to_currency(job[:salary_percentiles][:percentile_25]),
                max:   number_to_currency(job[:salary_percentiles][:percentile_75])
          }
    end
  end

  def self.number_to_currency(number)
    convert = ("$") + number.to_s
    string = convert.reverse.gsub(/(\d{3})(?=\d)/, '\\1,').reverse
    string.split(".")[0] + (".") + string.split(".")[1].slice(0..1)
  end
end
