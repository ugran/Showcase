Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: 'pages#index'
  match '/dashboard' => 'pages#dashboard', as: 'dashboard', via: [:get,:post]
  match '/about_us' => 'pages#about_us', as: 'about_us', via: [:get,:post]
  match '/contact' => 'pages#contact', as: 'contact', via: [:get,:post]
  match '/admin' => 'pages#admin', as: 'admin', via: [:get, :post, :patch]
  match '/products' => 'pages#products', as: 'products', via: [:get, :post]

  mount ActionCable.server => '/cable'
end
