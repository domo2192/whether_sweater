module Api
  module V1
    class UserController < ApplicationController

      def create
        params = JSON.parse(request.raw_post)
        user = User.create!(params)
        render json: UsersSerializer.new(user), status: :created
      end
    end
  end
end
