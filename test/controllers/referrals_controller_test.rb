require 'test_helper'

class ReferralsControllerTest < ActionDispatch::IntegrationTest
  include LinkBuilder

  test 'should return an error response if there is no valid params for the referral creation action' do
    assert_raises ActionController::ParameterMissing do
      post '/referrals'
    end
  end

  test 'should return an error response if the customer id param is not found in the database' do
    post '/referrals', params: { customer_id: 1 }

    assert_response :not_acceptable
  end

  test 'should return a success response with the sign up form link' do
    customer = Customer.create(username: 'username@email.com', password: '123')

    post '/referrals', params: { customer_id: customer.id }

    assert_equal customer, Referral.last.customer
    assert_response :created, build_sign_up_link('123')
  end
end
