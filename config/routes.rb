Rails.application.routes.draw do

  post 'static/enable_otp'
  post 'static/disable_otp'

  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'
  match '/dashboard' => 'pages#dashboard', as: 'dashboard', via: [:get,:post]
  match '/profile' => 'pages#profile', as: 'profile', via: [:get,:post]
  match '/showuser' => 'showuser#show_user', as: 'showuser', via: [:get, :post]
  match '/about_us' => 'static#about_us', as: 'about_us', via: [:get,:post]
  match '/contact' => 'static#contact', as: 'contact', via: [:get,:post]
  match '/admin' => 'admin#admin', as: 'admin', via: [:get, :post, :patch, :put]
  match '/products' => 'static#products', as: 'products', via: [:get, :post]
  match '/services' => 'static#services', as: 'services', via: [:get, :post]
  match '/our_facility' => 'static#our_facility', as: 'our_facility', via: [:get, :post]
  match '/test' => 'tests#index', as: 'test', via: [:get, :post]
  match '/locale' => 'pages#locale', as: 'locale', via: [:get, :post]
  match '/user_history' => 'pages#user_history', as: 'user_history', via: [:get, :post]
  match '/two_factor_authentication' => 'static#two_factor_authentication', as: 'two_factor_authentication', via: [:get,:post]

  mount ActionCable.server => '/cable'
  require 'sidekiq/web'
  Sidekiq::Web.set :session_secret, Rails.application.secrets[:secret_key_base]
  authenticate :user, lambda { |u| u.admin? } do
    mount Sidekiq::Web => '/sidekiq'
  end
end
