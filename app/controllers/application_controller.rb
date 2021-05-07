class ApplicationController < ActionController::API

  rescue_from ArgumentError, with: :render_param_error
  rescue_from ActiveRecord::RecordInvalid, with: :invalid_record

  def render_param_error
      render json: { message: "Your parameters are Invalid"}, status: 400
  end


  def invalid_record(error)
     render json: {error: error.message}, status: :bad_request
  end
end
