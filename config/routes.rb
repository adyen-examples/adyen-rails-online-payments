Rails.application.routes.draw do
  resource :checkout, except: ["new"]

  root 'checkouts#index'
  post 'initiatePayment', :to => 'checkouts#initiate_payment'
  get 'checkout/preview', :to => 'checkouts#preview'
  get 'checkout/confirmation', :to => 'checkouts#confirmation'

  post 'checkout/confirmation', :to => 'checkouts#details'

  # Payment results
  get 'error', :to => 'checkouts#error'
  get 'failed', :to => 'checkouts#failed'
  get 'pending', :to => 'checkouts#pending'
  get 'success', :to => 'checkouts#success'
  
  get 'checkout/:type', :to => 'checkouts#get_payment_methods'
end
