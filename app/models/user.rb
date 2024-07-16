class User < ApplicationRecord
  validates :name, presence: true, length: { minimum: 2 }, uniqueness: true
  validates :username, presence: true, length: { minimum: 6, maximum: 25 }, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :phone, presence: true
end
