class ApplicationController < ActionController::API

  rescue_from ArgumentError, with: :render_param_error

  def render_param_error
      render json: { message: "Your parameters are Invalid"}, status: 400
  end
end
