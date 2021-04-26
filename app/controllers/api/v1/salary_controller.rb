module Api
  module V1
    class SalaryController < ApplicationController

      def show
        salaries = SalaryFacade.get_salaries(params[:destination])
        render json: SalariesSerializer.new(salaries)
      end
    end
  end
end
