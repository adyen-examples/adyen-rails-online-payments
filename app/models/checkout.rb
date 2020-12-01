# Methods from the Adyen API Library for Ruby are defined here in the model and
# called from `CheckoutsController`.

# Note that certain values have been hard-coded for simplicity (i.e., you'll
# want to obtain some data from external resources or generate them at runtime).

require "adyen-ruby-api-library"

class Checkout < ApplicationRecord
  class << self

    # Makes the /paymentMethods request
    # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/paymentMethods
    def get_payment_methods()
      response = adyen_client.checkout.payment_methods({
        :merchantAccount => ENV["MERCHANT_ACCOUNT"],
        :channel => "Web",
      })

      response
    end

    # Makes the /payments request
    # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments
    def make_payment(payment_method, browser_info, remote_ip)
      currency = find_currency(payment_method["type"])
      order_ref = SecureRandom.uuid

      req = {
        :merchantAccount => ENV["MERCHANT_ACCOUNT"],
        :channel => "Web", # required
        :amount => {
          :currency => currency,
          :value => 1000, # value is 10€ in minor units
        },
        :reference => order_ref, # required
        :additionalData => {
          # required for 3ds2 native flow
          :allow3DS2 => "true",
        },
        :origin => "http://localhost:8080", #required for 3ds2 native flow
        :browserInfo => browser_info, # required for 3ds2
        :shopperIP => remote_ip, # required by some issuers for 3ds2
        # we pass the orderRef in return URL to get paymentData during redirects
        :returnUrl => "http://localhost:8080/api/handleShopperRedirect?orderRef=#{order_ref}", # required for 3ds2 redirect flow
        :paymentMethod => payment_method,  # required
      }

      response = adyen_client.checkout.payments(req)

      # store paymentData for redirect handling
      Checkout.create(name: order_ref, payment_data: response.response["paymentData"])

      response
    end

    # Makes the /payments/details request
    # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments/details
    def submit_details(details)
      response = adyen_client.checkout.payments.details(details)

      response
    end

    private

    def adyen_client
      @adyen_client ||= instantiate_checkout_client
    end

    def instantiate_checkout_client
      adyen = Adyen::Client.new
      adyen.api_key = ENV["API_KEY"]
      adyen.env = :test
      adyen
    end

    def find_currency(type)
      case type
      when "ach"
        return "USD"
      when "wechatpayqr", "alipay"
        return "CNY"
      when "dotpay"
        return "PLN"
      when "boletobancario"
        return "BRL"
      else
        return "EUR"
      end
    end
  end
end
