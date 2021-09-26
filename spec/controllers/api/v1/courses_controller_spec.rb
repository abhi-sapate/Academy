# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Api::V1::CoursesController, type: :controller do
  let!(:user) { create(:user) }

  describe '#index' do
    context 'Unauthorized request' do
      it 'Unauthorized request for no token' do
        post :index

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('login.failure.invalid_token'))
      end

      it 'Unauthorized request for invalid token' do
        token = user.generate_jwt
        request.headers['HTTP_AUTHORIZATION'] = "Bearer --#{token}"

        post :index

        expect(response.status).to eq(401)
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('login.failure.invalid_token'))
      end
    end

    context 'Authorized request' do
      before do
        request.headers['HTTP_AUTHORIZATION'] = "Bearer #{user.generate_jwt}"
      end

      it 'return data' do
        course = create(:course)
        tutor  = create(:tutor, course: course)

        post :index

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)).to eq(
          {
            'data' => [
              {
                'code' => 'DSA',
                'name' => 'Data Structures and Algorithms',
                'tutors' => [
                  {
                    'name' => tutor.name,
                    'faculty_no' => tutor.faculty_no
                  }
                ]
              }
            ]
          }
        )
      end
    end
  end

  describe '#create' do
    context 'Authorized request' do
      before do
        request.headers['HTTP_AUTHORIZATION'] = "Bearer #{user.generate_jwt}"
      end
      it 'create course and its tutors' do
        params = {
          "course":
            {
              "name": 'DSA1',
              "code": 'AB002',
              "tutors_attributes":
              [
                { "name": 'test', "faculty_no": '5139920631' },
                { "name": 'test2', "faculty_no": '1234567011' }
              ]
            }
        }

        post :create, params: params

        expect(response.status).to eq(200)
        expect(JSON.parse(response.body)['message']).to eq(I18n.t('course.created'))
      end

      it 'should not create course and its tutors' do
        course = create(:course, code: 'AB002')
        tutor = create(:tutor, faculty_no: '5139920631', course: course)

        params = {
          "course":
            {
              "name": 'DSA1',
              "code": 'AB002',
              "tutors_attributes":
              [
                { "name": 'test', "faculty_no": '5139920631' },
                { "name": 'test2', "faculty_no": '1234567011' }
              ]
            }
        }

        post :create, params: params

        expect(response.status).to eq(422)
        expect(JSON.parse(response.body)['message']).to eq(
          'Tutors faculty no has already been taken,Code has already been taken'
        )
      end
    end
  end
end
