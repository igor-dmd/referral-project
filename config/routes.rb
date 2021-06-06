Rails.application.routes.draw do
  get '/customers/:id', to: 'customers#show'
  post '/customers', to: 'customers#create'
  post '/customers/send-sign-up-link', to: 'customers#send_sign_up_link'

  post '/referrals', to: 'referrals#create'
end
