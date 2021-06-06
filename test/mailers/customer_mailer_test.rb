require 'test_helper'

class CustomerMailerTest < ActionMailer::TestCase
  include LinkBuilder

  test 'should send mail with the link to the sign up form containing the referral key' do
    email = CustomerMailer.send_sign_up_link('username@email.com', '123')

    # Send the email, then test that it got queued
    assert_emails 1 do
      email.deliver_now
    end

    assert_equal ['no-reply@referral-project.com'], email.from
    assert_equal ['username@email.com'], email.to
    assert_equal 'Sign up link for Referral Project', email.subject
    assert_match build_sign_up_link('123'), email.body.to_s
  end
end
