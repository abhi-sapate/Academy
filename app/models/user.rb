class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, uniqueness: { case_sensitive: false }, presence: true

  def generate_jwt
    JWT.encode({ id: id, exp: 2.hours.from_now.to_i }, JWT_SECRET)
  end
end
