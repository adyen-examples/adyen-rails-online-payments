# Methods from the Adyen API Library for Ruby are defined here in the model and
# called from `CheckoutsController`.

# Note that certain values have been hard-coded for simplicity (i.e., you'll
# want to obtain some data from external resources or generate them at runtime).

require "adyen-ruby-api-library"

class Checkout
  class << self

    # Initiates the session
    def adyen_session(localhost)
      order_ref = SecureRandom.uuid
      req = {
        :amount => {
          :currency => "EUR",
          :value => 1000, # value is 10€ in minor units
        },
        :merchantAccount => ENV["ADYEN_MERCHANT_ACCOUNT"],
        :reference => order_ref,
        :returnUrl => "#{localhost}/api/handleShopperRedirect?orderRef=#{order_ref}",
        :countryCode => "NL",
        # lineItems required for some payment methods (ie Klarna)
        :lineItems => [
          {
            :quantity => 1,
            :amountIncludingTax => 5000, # value is 10€ in minor units
            :description => "Sunglasses"
          },
          {
            :quantity => 1,
            :amountIncludingTax => 5000, # value is 10€ in minor units
            :description => "Headphones"
          }
        ]
      }
      puts req.to_json
      response = adyen_client.checkout.sessions(req)
      puts response.to_json
      response
    end

    # Makes the payment redirect
    def submit_details(details)
      response = adyen_client.checkout.payments.details(details)
      puts response.to_json
      response
    end

    # Process incoming webhook notifications
    def adyen_webhooks(notifications)
      hmacKey = ENV["ADYEN_HMAC_KEY"]
      validator = Adyen::Utils::HmacValidator.new
      notifications.each do |notification|
        validationItem =  notification["NotificationRequestItem"]
        if validator.valid_notification_hmac?(validationItem, hmacKey)
          puts validationItem["eventCode"]
          puts validationItem["merchantReference"]
        else
          # In case of invalid hmac, do not send [accepted] response
          raise "Invalid HMAC Signature"
        end
      end
      "[accepted]"
    end

    private

    def adyen_client
      @adyen_client ||= instantiate_checkout_client
    end

    def instantiate_checkout_client
      adyen = Adyen::Client.new
      adyen.api_key = ENV["ADYEN_API_KEY"]
      adyen.env = :test
      adyen
    end
  end
end
