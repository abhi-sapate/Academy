# frozen_string_literal: true

FactoryBot.define do
  factory :tutor do
    name { Faker::Name.name }
    faculty_no { Faker::Number.number(digits: 10) }
  end
end
