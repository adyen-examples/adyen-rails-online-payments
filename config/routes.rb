Rails.application.routes.draw do
  resource :checkout, except: ["new"]

  root 'checkouts#index'
  get 'preview', :to => 'checkouts#preview'
  
  # APIs
  post 'api/initiatePayment', :to => 'checkouts#initiate_payment'
  get 'api/handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'api/handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'api/submitAdditionalDetails', :to => 'checkouts#submit_additional_details'

  # Payment results
  get 'error', :to => 'checkouts#error'
  get 'failed', :to => 'checkouts#failed'
  get 'pending', :to => 'checkouts#pending'
  get 'success', :to => 'checkouts#success'
  
  get 'checkout/:type', :to => 'checkouts#get_payment_methods'
end
