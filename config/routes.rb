Rails.application.routes.draw do
  resource :checkout, except: ["new"]

  root 'checkouts#index'
  get 'preview', :to => 'checkouts#preview'
  get 'checkout/:type', :to => 'checkouts#checkout'
  # Payment results
  get 'result/:type', :to => 'checkouts#result'

  # APIs
  get 'api/handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'api/handleShopperRedirect', :to => 'checkouts#handle_shopper_redirect'
  post 'api/sessions', :to => 'checkouts#adyen_sessions'
end
