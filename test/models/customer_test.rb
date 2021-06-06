require 'test_helper'

class CustomerTest < ActiveSupport::TestCase
  test 'should validate the presence of the username field' do
    customer = Customer.create(password: '123')

    assert_not customer.save
  end

  test 'should validate the presence of the password field' do
    customer = Customer.create(username: 'username@email.com')

    assert_not customer.save
  end

  test 'should not allow entries with duplicate username fields' do
    Customer.create(password: '123', username: 'username@email.com')

    customer2 = Customer.create(password: '456', username: 'username@email.com')

    assert_not customer2.save
  end

  test 'should validate that the username field is a valid email' do
    customer = Customer.create(password: '123', username: 'username')

    assert_not customer.save
  end

  test 'should create default value for the cash field' do
    customer = Customer.create(username: 'username@email.com', password: '123')

    assert customer.save
    assert_equal 0, customer.cash
  end

  test 'should format and parse the customer entry when the to_response method is called' do
    customer = Customer.create(username: 'username@email.com', password: '123')

    customer_json = {
      id: customer.id,
      username: customer.username,
      cash: customer.cash,
      referrals: customer.referrals
    }.to_json

    assert_not_equal customer, customer_json
    assert_equal customer.to_response, customer_json
  end
end
