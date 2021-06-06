##
# Defines the helpers and methods available for the customer entry.
class Customer < ApplicationRecord
  has_secure_password
  has_many :referrals
  validates :username, :cash, :password, presence: true
  validates :username,
            format: { with: URI::MailTo::EMAIL_REGEXP, message: 'Invalid Email.' },
            uniqueness: { case_sensitive: false },
            length: { minimum: 4, maximum: 254 }
  before_validation :default_values

  ##
  # Assign default values for the not assigned fields before the validation happens
  def default_values
    self.cash ||= 0.0
  end

  ##
  # Updates the customer attributes after a customer creation with referral
  def update_after_referral!
    update_attribute(:cash, 10.0)
  end

  ##
  # Formats the customer entry to display only the most important data and parses it into a json.
  def to_response
    slice(:id, :username, :cash, :referrals).to_json
  end
end
