class User < ApplicationRecord
  has_secure_password
  validates :email, presence: true, uniqueness: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :firstName, presence: true
  validates :lastName, presence: true
  validates :attachment, presence: false
  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }
end
