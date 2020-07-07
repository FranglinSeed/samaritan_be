Rails.application.routes.draw do
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'
  post '/createRequest', to: 'authentication#createRequest'
  get '/getRequests', to: 'authentication#getRequests'
  get '/*a', to: 'application#not_found'
end