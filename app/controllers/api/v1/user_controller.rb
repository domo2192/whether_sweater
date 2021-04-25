module Api
  module V1
    class UserController < ApplicationController

      def create
        User.create(user_params)
      end

      private
      def user_params
        params.require(:email, :password, :password_confirmation)
      end
    end
  end
end
