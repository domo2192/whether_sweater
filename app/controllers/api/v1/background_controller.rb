module Api
  module V1
    class BackgroundController < ApplicationController

      def show
        if params[:location].present?
          background = BackgroundFacade.get_background(params[:location])
          render json: BackgroundSerializer.new(background)
        else
          render_param_error
        end 
      end
    end
  end
end
