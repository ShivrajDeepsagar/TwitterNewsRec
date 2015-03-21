Rails.application.routes.draw do
  get '/auth/:provider/callback', to: 'sessions#create'
  get 'signout', to: 'sessions#destroy', as: 'signout'
  resources :tweets

  root to: "tweets#index"
end
