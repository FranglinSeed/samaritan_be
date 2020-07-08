Rails.application.routes.draw do
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'
  post '/createRequest', to: 'main#createRequest'
  get '/getRequests', to: 'main#getRequests'
  post '/createMessage', to: 'main#createMessage'
  post '/getMessage', to: 'main#getMessage'
  post '/getHelper', to: 'main#getHelper'
  get '/*a', to: 'application#not_found'
end