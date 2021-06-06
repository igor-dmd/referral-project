# frozen_string_literal: true
require 'test_helper'

class ReferralTest < ActiveSupport::TestCase
  def setup
    @referral = Referral.create(customer: Customer.new(username: 'username@email.com', password: '123'))
  end

  test 'should not allow the creation of referral entries with duplicate key fields' do
    referral2 = Referral.create(key: @referral.key)

    assert_not referral2.save
  end

  test 'should assign default values for the key and referred count after the referral entry creation' do
    assert @referral.save
    assert_equal 0, @referral.referred_count
    assert_instance_of String, @referral.key
  end

  test 'should increment just the referred count field in the update after referral method' do
    assert_equal 0, @referral.referred_count
    assert_equal 0, @referral.customer.cash

    @referral.update_after_referral!

    assert_equal 1, @referral.referred_count
    assert_equal 0, @referral.customer.cash
  end

  test 'should update the referred count and the customer field in the update after referral method' do
    assert_equal 0, @referral.referred_count
    assert_equal 0, @referral.customer.cash

    @referral.referred_count = 4
    @referral.update_after_referral!

    assert_equal 5, @referral.referred_count
    assert_equal 10.0, @referral.customer.cash
  end
end
