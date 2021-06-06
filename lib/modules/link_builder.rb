##
# Module that defines a method to build the sign up form link so we can use it in the mailing related tasks.
module LinkBuilder
  ##
  # Builds the full HTTPS link for accessing the sign up form using the given referral key.
  def build_sign_up_link(referral_key)
    URI::HTTPS.build(
      host: ENV['REFERRAL_PROJECT_HOST'],
      path: ENV['SIGN_UP_FORM_PATH'],
      query: { referral_key: referral_key }.to_query
    ).to_s
  end
end
