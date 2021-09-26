# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Name.first_name }
    email { Faker::Internet.email }
    password { 'abhi@123' }
  end
end
