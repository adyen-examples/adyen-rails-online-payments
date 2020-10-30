Rails.application.routes.draw do
  resource :checkout, except: ["new"]

  root 'checkouts#index'
  get 'preview', :to => 'checkouts#preview'
  get 'checkout/:type', :to => 'checkouts#checkout'
  # Payment results
  get 'result/:type', :to => 'checkouts#result'

  # APIs
  post 'api/getPaymentMethods', :to => 'checkouts#get_payment_methods'
  post 'api/initiatePayment', :to => 'checkouts#initiate_payment'
  get 'api/handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'api/handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'api/submitAdditionalDetails', :to => 'checkouts#submit_additional_details'
end
