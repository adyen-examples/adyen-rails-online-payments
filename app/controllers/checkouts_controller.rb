require 'json'

class CheckoutsController < ApplicationController
  def index
  end

  def preview
    @type = params[:type]
  end

  def new
    # The call to /paymentMethods will be made as the checkout page is requested.
    # The response will be passed to the front end via an instance variable,
    # which will be used to configure the instance of `AdyenCheckout`
    payment_methods_response = Checkout.get_payment_methods.body

    @resp = payment_methods_response
    @origin_key = ENV["ORIGIN_KEY"]
    @type = params[:type]

    # The payment template (payment_template.html.erb) will be rendered with the
    # appropriate integration type (based on the params supplied).
    render 'payment_template'
  end

  def create
    # The call to /payments will be made as the shopper makes a payment.
    payment_response = Checkout.make_payment(params["paymentMethod"])
    
    # The Adyen API Library for Ruby currently returns a `Faraday` object with a
    # `body` parameter, so we'll need to do some quick parsing of the response.
    payment_response_hash = JSON.parse(payment_response.body)

    result_code = payment_response_hash["resultCode"]

    # Alternatively, you can build your controller logic to first check for
    # an `action` object in the /payments response. For example, Drop-in will
    # automatically handle `action` objects and perform additional front-end
    # actions on its own (depending on `action.type`).
    # For more details: https://docs.adyen.com/checkout/drop-in-web#step-4-additional-front-end
    action = payment_response_hash["action"]
    paymentMethodType = params["paymentMethod"]["type"]

    case result_code
      when "Authorised"
        redirect_to '/checkout/confirmation'
      when "RedirectShopper"
        if paymentMethodType == "ideal"
          redirect_to payment_response_hash["redirect"]["url"]
        end

        if paymentMethodType == "scheme"
          # For the purpose of this demo, payment data is saved in a Rails session.
          # It is up to you how you choose to handle state (that is, keeping it
          # on the client side versus connecting to a database).
          session[:payment_data] = payment_response_hash["paymentData"]
          render json: action
        end
      when "Error"
        # Generic error page
        redirect_to '/checkout/error'
      else
        # Handle other results
        # https://docs.adyen.com/checkout/payment-result-codes
    end
  end

  def details
    payload = {}
    details = {}
    details["MD"] = params["MD"]
    details["PaRes"] = params["PaRes"]
    payload["details"] = details
    payload["paymentData"] = session[:payment_data]

    # The call to /payments/details will be made to submit 3D Secure 2
    # authentication results and to complete the payment.
    resp = Checkout.submit_details(payload)
    resp_hash = JSON.parse(resp.body)

    session[:payment_data] = ""

    if resp_hash["resultCode"] == "Authorised"
      redirect_to '/checkout/confirmation'
    else
      redirect_to '/checkout/error'
    end
  end

  def confirmation
  end

  def error
  end
end
