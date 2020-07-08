class Conversation < ApplicationRecord
  belongs_to :request
  belongs_to :user
  belongs_to :message
end
