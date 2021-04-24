module Api
  module V1
    class ForecastController < ApplicationController

      def show
        if params[:location]
        weather = WeatherFacade.get_forecast(params[:location])
        render json: ForecastSerializer.new(weather)
        else
          render_param_error
        end
      end
    end
  end
end
