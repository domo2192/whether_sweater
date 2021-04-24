module Api
  module V1
    class ForecastController < ApplicationController

      def show
        weather = WeatherFacade.get_forecast(params[:location])
        render json: ForecastSerializer.new(weather)
      end
    end
  end
end
