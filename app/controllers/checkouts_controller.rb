require "json"

class CheckoutsController < ApplicationController
  def index
  end

  def preview
    @type = params[:type]
  end

  def checkout
    @type = params[:type]
    @client_key = ENV["CLIENT_KEY"]

    # The payment template (payment_template.html.erb) will be rendered with the
    # appropriate integration type (based on the params supplied).
    render "payment_template"
  end

  def result
    @type = params[:type]
  end

  def get_payment_methods
    # The call to /paymentMethods will be made as the checkout page is requested.
    # The response will be passed to the front end,
    # which will be used to configure the instance of `AdyenCheckout`
    payment_methods_response = Checkout.get_payment_methods().response.to_json

    render json: payment_methods_response
  end

  def initiate_payment
    # The call to /payments will be made as the shopper selects the pay button.
    payment_response = Checkout.make_payment(params["paymentMethod"], params["riskData"].to_json, params["browserInfo"].to_json, request.remote_ip).response

    render json: payment_response
  end

  def handle_shopper_redirect
    payload = {}
    payload["details"] = params
    payload["paymentData"] = Checkout.find_by(name: params["orderRef"]).payment_data

    resp = Checkout.submit_details(payload).response

    case resp["resultCode"]
    when "Authorised"
      redirect_to "/result/success"
    when "Pending", "Received"
      redirect_to "/result/pending"
    when "Refused"
      redirect_to "/result/failed"
    else
      redirect_to "/result/error"
    end
  end

  def submit_additional_details
    payload = {}
    payload["details"] = params["details"]
    payload["paymentData"] = params["paymentData"]

    resp = Checkout.submit_details(payload).response

    render json: resp
  end
end
