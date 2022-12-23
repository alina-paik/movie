class ApplicationController < ActionController::Base
  include ActionPolicy::Controller
  authorize :user, through: :current_user

  attr_reader :current_user

  def authentication
    decode_data = decode_user_data(request.cookies['session'])
    user_id = decode_data[0]['user_id'] if decode_data
    @current_user = User.find(user_id) if user_id

    if current_user
      true
    else
      render json: { message: 'user is unauthorized' }, status: :unauthorized
    end
  end

  def encode_user_data(payload)
    JWT.encode payload, ENV['SECRET'], 'HS256'
  end

  def decode_user_data(token)
    JWT.decode token, ENV['SECRET'], true, algorithm: 'HS256'
  rescue StandardError => e
    puts e
  end
end
