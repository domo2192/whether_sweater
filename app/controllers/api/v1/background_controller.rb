module Api
  module V1
    class BackgroundController < ApplicationController

      def show
        background = BackgroundFacade.get_background(params[:location])
        require "pry"; binding.pry
      end
    end
  end
end
