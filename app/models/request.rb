class Request < ApplicationRecord
  belongs_to :user
  validates :user_id, presence: true
  validates :description, presence: true
  validates :requestType, presence: true
  validates :latitude, presence: true
  validates :longitude, presence: true
  validates :address, presence: true
  validates :status, presence: false
end
