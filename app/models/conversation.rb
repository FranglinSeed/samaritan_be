class Conversation < ApplicationRecord
  belongs_to :request
  belongs_to :user
  belongs_to :message
  validates :request_id, presence: true
  validates :user_id, presence: true
  validates :message_id, presence: true, uniqueness: true
end
