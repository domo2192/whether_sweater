module Api
  module V1
    class SessionController < ApplicationController

      def create
        @user = User.find_by(email: params[:email].downcase)
        if @user && @user.authenticate(params[:password])
          render json: UsersSerializer.new(@user)
        else
          render json: { error: "Your credentials are bad!! Fix it!"}, status: 400
        end
      end
    end
  end
end
