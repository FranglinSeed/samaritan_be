class Request < ApplicationRecord
  belongs_to :user
  validates :description, presence: true
  validates :requestType, presence: true
  validates :latitude, presence: false
  validates :longitude, presence: false
  validates :address, presence: false
end
