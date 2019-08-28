Rails.application.routes.draw do
  namespace :api do
    namespace :v0 do
      resources :articles, only: [:index, :create]
      resources :subscriptions, only: [:new, :create, :index]
      resources :users, only: [:show]
    end
  end
  mount_devise_token_auth_for 'User', at: 'api/v0/auth', skip: [:omniauth_callbacks], controllers: {
    registrations: :registrations
  }
end
