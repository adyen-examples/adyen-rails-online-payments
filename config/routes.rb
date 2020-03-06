Rails.application.routes.draw do
  resource :checkout, except: ["new"]

  root 'checkouts#index'
  get 'checkout/preview', :to => 'checkouts#preview'
  post 'initiatePayment', :to => 'checkouts#initiate_payment'
  get 'handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'submitAdditionalDetails', :to => 'checkouts#submit_additional_details'

  # Payment results
  get 'error', :to => 'checkouts#error'
  get 'failed', :to => 'checkouts#failed'
  get 'pending', :to => 'checkouts#pending'
  get 'success', :to => 'checkouts#success'
  
  get 'checkout/:type', :to => 'checkouts#get_payment_methods'
end
