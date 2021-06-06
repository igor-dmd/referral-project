require 'test_helper'

class ReferralFlowTest < ActionDispatch::IntegrationTest
  include LinkBuilder

  def setup
    assert_equal 0, Customer.count
    assert_equal 0, Referral.count

    post '/customers', params: { username: 'username@email.com', password: '123' }
    assert_response :created
    assert_equal 1, Customer.count

    @first_customer = Customer.last
    assert_equal 0.0, @first_customer.cash

    post '/referrals', params: { customer_id: @first_customer.id }
    assert_response :created, build_sign_up_link(@first_customer.referrals.last.key)
    assert_equal 1, Referral.count

    @first_referral = @first_customer.referrals.first
    assert_equal 0, @first_referral.referred_count
  end

  ##
  # Retrieves the customer data so we can check the information returned from the response
  # instead of checking the records on the database.
  def get_customer(id)
    get "/customers/#{id}"

    @customer_hash = JSON.parse(response.body)
    @referral_hash = @customer_hash['referrals'].last

    assert_response :ok
  end

  test 'customer creates a referral and another 5 customers sign up with that referral' do
    (1..4).each do |i|
      post '/customers', params: {
        username: "username#{i}@email.com",
        password: '123',
        referral_key: @first_referral.key
      }
      assert_response :created

      get_customer(@first_customer.id)
      assert_equal i, @referral_hash['referred_count']
      assert_equal 0.0, @customer_hash['cash']

      get_customer(Customer.last.id)
      assert_equal 10.0, @customer_hash['cash']
    end

    post '/customers', params: {
      username: 'username5@email.com',
      password: '123',
      referral_key: @first_referral.key
    }
    assert_response :created

    get_customer(@first_customer.id)
    assert_equal 5, @referral_hash['referred_count']
    assert_equal 10.0, @customer_hash['cash']

    get_customer(Customer.last.id)
    assert_equal 10.0, @customer_hash['cash']
  end

  test 'customer sends the sign up form link for a new customer that uses that referral key to sign up' do
    # Gets referral parameter from the last referral creation response, which contains the sign up form link
    referral_query_param = URI.parse(response.body).query.to_s.split('=')[1]

    post '/customers', params: {
      username: 'username5@email.com',
      password: '123',
      referral_key: referral_query_param
    }
    assert_response :created

    get_customer(@first_customer.id)
    assert_equal 1, @referral_hash['referred_count']
  end
end
