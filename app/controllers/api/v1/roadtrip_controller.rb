module Api
  module V1
    class RoadtripController < ApplicationController

      def show
        @user = User.find_by(api_key: params[:api_key])
        if @user.nil?
          render json: { error: "Unauthorized"}, status: 401
        else
          roadtrip = RoadtripFacade.get_roadtrip(params[:origin], params[:destination])
          render json: RoadtripSerializer.new(roadtrip)
        end
      end
    end
  end
end
