module Api
  module V1
    class SalaryController < ApplicationController

      def show
        if params[:destination] && !params[:destination].empty?
          salaries = SalaryFacade.get_salaries(params[:destination])
          render json: SalariesSerializer.new(salaries)
        else
          render_param_error
        end
      end
    end
  end
end
