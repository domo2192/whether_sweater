module Api
  module V1
    class SalaryController < ApplicationController

      def show
        salaries = SalaryFacade.get_salaries(params[:destination])
      end
    end
  end
end
