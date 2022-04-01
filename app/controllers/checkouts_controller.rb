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

  def adyen_sessions
    response = Checkout.adyen_sessions()

    render json: response.response, status: response.status
  end

  def handle_shopper_redirect
    payload = {}
    payload["details"] = {
      "redirectResult" => params["redirectResult"],
    }

    response = Checkout.submit_details(payload).response

    case response["resultCode"]
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
end
