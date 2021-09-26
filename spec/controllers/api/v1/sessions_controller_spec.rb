# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :controller do
  let!(:user) { create(:user, username: 'abhi', password: 'abhi@123') }
  let!(:params) do
    {
      session: {
        login: 'abhi',
        password: 'abhi@123'
      }
    }
  end

  describe '#token' do
    context 'wrong username and password in headers' do
      it 'should return invalid_credentials error' do
        params[:session][:login] = 'abhish'
        post :auth_token, params: params

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('login.failure.invalid'))
      end
    end

    context 'correct username and password in headers' do
      it 'should return auth token' do
        post :auth_token, params: params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['token']).to eq(user.generate_jwt)
      end
    end
  end
end
