require 'test_helper'
require 'minitest/autorun'

class CustomersControllerTest < ActionDispatch::IntegrationTest
  test 'should raise an error if there are no valid body params in the create action' do
    assert_raises ActionController::ParameterMissing do
      post '/customers'
    end

    assert_raises ActionController::ParameterMissing do
      post '/customers', params: { username: 'username@email.com' }
    end

    assert_raises ActionController::ParameterMissing do
      post '/customers', params: { password: '123' }
    end
  end

  test 'should create the user entry when the request is made with valid params, but no referral code' do
    post '/customers', params: { username: 'username@email.com', password: 'username' }

    assert_response :created
    assert_equal 0.0, Customer.last.cash
    assert_equal Customer.last.to_response, response.body
  end

  test 'should give an error response when the create request comes with an invalid referral key' do
    post '/customers',
         params: { username: 'username@email.com', password: 'username', referral_key: 'referral123' }

    assert_response :not_acceptable
  end

  test 'should verify if the customer data gets properly updated during sign up actions with valid referral keys' do
    customer = Customer.create({
                                 username: 'username@email.com',
                                 password: '123',
                                 referrals: [
                                   Referral.create
                                 ]
                               })

    assert_equal 0, customer.cash
    assert_equal 0, customer.referrals.last.referred_count

    (1..4).each do |i|
      post '/customers', params: {
        username: "username#{i}@email.com",
        password: '123',
        referral_key: customer.referrals.last.key
      }

      assert_response :created
      assert_equal 10.0, Customer.last.cash
      assert_equal 0.0, customer.reload.cash
      assert_equal i, customer.reload.referrals.last.referred_count
    end

    post '/customers', params: {
      username: 'username5@email.com',
      password: '123',
      referral_key: customer.reload.referrals.last.key
    }

    assert_response :created
    assert_equal 5, customer.reload.referrals.last.referred_count
    assert_equal 10.0, customer.reload.cash
  end

  test 'should return an error response if there are no valid body params in the send sign up link action' do
    assert_raises ActionController::ParameterMissing do
      post '/customers/send-sign-up-link'
    end

    assert_raises ActionController::ParameterMissing do
      post '/customers/send-sign-up-link', params: { username: 'username@email.com' }
    end

    assert_raises ActionController::ParameterMissing do
      post '/customers/send-sign-up-link', params: { referral_key: '123' }
    end
  end

  test 'should return an error if the username is not a valid email in the send sign up link action' do
    customer = Customer.create({
                                 username: 'username@email.com',
                                 password: '123',
                                 referrals: [
                                   Referral.create
                                 ]
                               })

    post '/customers/send-sign-up-link', params: {
      username: 'username',
      referral_key: customer.referrals.last.key
    }

    assert_response :bad_request
  end

  test 'should return an error if the referral key is invalid in send sign up link action' do
    customer = Customer.create({
                                 username: 'username@email.com',
                                 password: '123',
                                 referrals: [
                                   Referral.create
                                 ]
                               })

    post '/customers/send-sign-up-link', params: {
      username: 'username@email.com',
      referral_key: '123'
    }

    assert_not_equal '123', customer.referrals.last.key
    assert_response :not_acceptable
  end

  test 'should send the mail and return return a success response for the sign up link action' do
    customer = Customer.create({
                                 username: 'username@email.com',
                                 password: '123',
                                 referrals: [
                                   Referral.create
                                 ]
                               })

    assert_emails 0

    post '/customers/send-sign-up-link', params: {
      username: 'username@email.com',
      referral_key: customer.referrals.last.key
    }

    assert_emails 1
    assert_response :ok
  end

  test 'should return an error if the id passed to the customer show action does not exist' do
    assert_raises ActiveRecord::RecordNotFound do
      get '/customers/1'
    end
  end

  test 'should return the customer data if the id parameter is valid for the show action' do
    customer = Customer.create(username: 'username@email.com', password: '123')

    get "/customers/#{customer.id}"

    assert_response :ok
    assert_equal customer.to_response, response.body
  end
end
