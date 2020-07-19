Rails.application.routes.draw do
  resources :users, param: :_username
  post '/auth/login', to: 'authentication#login'
  post '/createRequest', to: 'main#createRequest'
  post '/activeRequest', to: 'main#activeRequest'
  get '/getRequests', to: 'main#getRequests'
  post '/getDeactivatedRequests', to: 'main#getDeactivatedRequests'
  post '/createMessage', to: 'main#createMessage'
  post '/getMessage', to: 'main#getMessage'
  post '/getHelper', to: 'main#getHelper'
  post '/getRequestUser', to: 'main#getRequestUser'
  get '/*a', to: 'application#not_found'
end