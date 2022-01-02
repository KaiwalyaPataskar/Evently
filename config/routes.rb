Rails.application.routes.draw do
  root 'users#index'

  resources :events
  resources :users do
    get :sync_events, on: :member
  end

  get :oauth_callback, to: 'users#oauth_callback'
end
