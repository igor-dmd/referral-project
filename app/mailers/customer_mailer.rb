##
# Defines actions and helper methods to send mails to customers
class CustomerMailer < ApplicationMailer
  include LinkBuilder

  default from: ENV['DEFAULT_SENDER_EMAIL']

  ##
  # Sends the email for a given username and passes the sign up form link
  # along with a given referral key.
  def send_sign_up_link(username, referral_key)
    mail(to: username,
         subject: 'Sign up link for Referral Project',
         body: "Here's the link to the sign up form: #{build_sign_up_link(referral_key)}",
         content_type: 'text/html')
  end
end
