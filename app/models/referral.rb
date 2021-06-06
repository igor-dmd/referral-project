##
# Defines the structure and model logic for referral entries
class Referral < ApplicationRecord
  belongs_to :customer
  validates :key, :referred_count, presence: true
  validates :key, uniqueness: true
  before_validation :default_values

  ##
  # Assign default values for the not assigned fields before the validation happens
  def default_values
    self.key ||= SecureRandom.hex(10)
    self.referred_count ||= 0
  end

  ##
  # Updates the referral attributes after a customer creation with referral
  def update_after_referral!
    update_attribute(:referred_count, referred_count + 1)

    customer.update_attribute(:cash, customer.cash + 10) if !referred_count.zero? && (referred_count % 5).zero?
  end
end
