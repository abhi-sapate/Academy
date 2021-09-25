class Api::V1::SessionsController < ApplicationController
  def auth_token
    username = params['session']['login']
    password = params['session']['password']

    load_user(username)

    if @user && @user.valid_password?(password)
      token = @user.generate_jwt
      render json: { token: token }, status: :ok
    else
      render json: { message: I18n.t('login.failure.invalid') }, status: :unauthorized
    end
  end

  private

  def load_user(username)
    @user = User.find_by(username: username)
  end
end
