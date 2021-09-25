class BaseController < ApplicationController
  before_action :validate_jwt_token!
  before_action :authenticate_user_from_token!

  def current_user
    @current_user ||= begin
      User.where(id: jwt_payload['id']).first
    rescue StandardError
      nil
    end
  end

  def jwt_payload
    token = request.headers['HTTP_AUTHORIZATION'] || ''
    token = token.gsub(/Bearer /, '')
    @jwt_payload ||= JWT.decode(token, JWT_SECRET)[0]
  end

  def status_check
    render nothing: true, status: :ok
  end

  private

  def validate_jwt_token!
    jwt_payload
  rescue JWT::VerificationError, JWT::DecodeError
    token_invalid && return
  end

  def authenticate_user_from_token!
    current_user.present?
  rescue NameError
    token_invalid && return
  end

  def token_invalid
    render json: { message: I18n.t('login.failure.invalid_token') }, status: :unauthorized
  end
end
