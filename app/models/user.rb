class User < ApplicationRecord
  attribute :cash, :integer, default: 0
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
end
