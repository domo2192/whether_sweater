module Api
  module V1
    class BackgroundController < ApplicationController

      def show
        background = BackgroundFacade.get_background(params[:location])
        render json: BackgroundSerializer.new(background)
      end
    end
  end
end
