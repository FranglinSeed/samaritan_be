Rails.application.routes.draw do
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'
  post '/createRequest', to: 'main#createRequest'
  get '/getRequests', to: 'main#getRequests'
  get '/*a', to: 'application#not_found'
end