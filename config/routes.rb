Rails.application.routes.draw do
  resource :checkout, except: ["new"]

  root 'checkouts#index'
  get 'checkout/preview', :to => 'checkouts#preview'
  get 'checkout/confirmation', :to => 'checkouts#confirmation'
  # Drop-in will POST to the returnUrl specified (see model)
  post 'checkout/confirmation', :to => 'checkouts#details'
  get 'checkout/error', :to => 'checkouts#error'
  # URI pattern for dropin, card, and ideal are dynamically generated
  # and will hit the #new endpoint in the controller
  get 'checkout/:type', :to => 'checkouts#new'
end
