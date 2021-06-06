##
# Defines the actions to deal with the Referral model operations
class ReferralsController < ApplicationController
  include LinkBuilder

  ##
  # Creates a new referral entry and associates it with the customer id parameter
  def create
    params.require(:customer_id)

    customer = Customer.find_by(id: params[:customer_id])
    render json: 'Customer ID not found.', status: :not_acceptable and return if customer.nil?

    referral = Referral.create do |r|
      r.customer = customer
    end

    if referral.save
      render json: build_sign_up_link(referral.key), status: :created
    else
      render json: 'There was a problem with the referral creation.', status: :bad_request
    end
  end
end
