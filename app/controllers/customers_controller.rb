##
# The controller responsible for handle the actions related to the customer model.
class CustomersController < ApplicationController
  ##
  # The action that creates a customer entry and verifies tha validity of the passed referral parameter.
  #
  # It returns error HTTP responses for when the creation has an error or if the referral is not valid.
  def create
    params.require(:username)
    params.require(:password)

    customer = Customer.new(params.permit(:username, :password))
    unless params[:referral_key].nil?
      referral = Referral.find_by(key: params[:referral_key])

      if referral.nil?
        render json: {
          error: 'Referral key is invalid.',
          status: 406
        }, status: :not_acceptable and return
      end

      customer.update_after_referral!
      referral.update_after_referral!
    end

    if customer.save
      render json: customer.to_response, status: :created
    else
      render json: {
        error: 'Customer creation failed.',
        status: 400
      }, status: :bad_request
    end
  end

  ##
  # Action that sends an email for a given username with the sign up form link
  def send_sign_up_link
    params.require(:username)
    params.require(:referral_key)

    if params[:username].match(URI::MailTo::EMAIL_REGEXP).nil?
      render json: 'Invalid username. Use a valid email address.', status: :bad_request and return
    end

    unless Referral.exists?(key: params[:referral_key])
      render json: 'Referral key is invalid.', status: :not_acceptable and return
    end

    CustomerMailer.send_sign_up_link(params[:username], params[:referral_key]).deliver_now

    render json: 'Message sent.', status: :ok
  end

  ##
  # Retrieves the information of a specific customer entry
  def show
    render json: Customer.find(params[:id]).to_response, status: :ok
  end
end
