Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'posts#index'

  resources :posts, except: [:index] do
    resources :comments, shallow: true, only: [:create, :destroy]
  end

  resources :users, only: [:new, :create, :edit, :update]
  resource :session, only: [:new]
  resources :sessions, only: [:create, :destroy]
end
