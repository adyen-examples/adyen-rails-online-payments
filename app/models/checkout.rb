# Methods from the Adyen API Library for Ruby are defined here in the model and
# called from `CheckoutsController`.

# Note that certain values have been hard-coded for simplicity (i.e., you'll
# want to obtain some data from external resources or generate them at runtime).

require 'adyen-ruby-api-library'

class Checkout < ApplicationRecord
  class << self;
    def find_currency(type)
      case type
      when 'ach'
        return "USD"
      when 'ideal', 'giropay', "klarna_paynow", "sepadirectdebit", "directEbanking"
        return "EUR"
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

    # Makes the /paymentMethods request
    # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/paymentMethods
    def get_payment_methods()
      response = adyen_client.checkout.payment_methods({
        :merchantAccount => ENV["MERCHANT_ACCOUNT"],
        :channel => 'Web'
      })

      response
    end

    # Makes the /payments request
    # https://docs.adyen.com/api-explorer/#/PaymentSetupAndVerificationService/payments
    def make_payment(payment_method, risk_data, browser_info)
      currency = find_currency(payment_method["type"])

      response = adyen_client.checkout.payments({
        :amount => {
          :currency => currency,
          :value => 1000
        },
        :shopperIP => "192.168.1.3",
        :channel => "Web",
        :reference => "12345",
        :additionalData => {
          :executeThreeD => "true"
        },
        :returnUrl => "http://localhost:8080/api/handleShopperRedirect",
        :merchantAccount => ENV["MERCHANT_ACCOUNT"],
        :paymentMethod => payment_method,
        :browserInfo => browser_info,
        :riskData => risk_data
      })

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
  end
end
