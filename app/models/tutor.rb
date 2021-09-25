class Tutor < ApplicationRecord
  belongs_to :course

  validates :name, presence: true
  validates :faculty_no, presence: true, uniqueness: true, length: { is: 10 }, allow_blank: false
end
