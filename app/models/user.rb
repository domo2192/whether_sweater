class User < ApplicationRecord
  validates :email, uniqueness: true, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates_confirmation_of :password
  validates :password, presence: { require: true }
  before_save { email.try(:downcase!) }
  before_save :set_api_key
  has_secure_password

  def set_api_key
    self.api_key =  SecureRandom.base58(24)
  end
end
