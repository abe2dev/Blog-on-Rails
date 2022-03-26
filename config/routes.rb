Rails.application.routes.draw do
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Defines the root path route ("/")
  # root "articles#index"
  root to: 'posts#index'

  resources :posts, except: [:index] do
    resources :comments, shallow: true, only: %i[create destroy]
  end
  get '/change_password', to: 'users#change_password', as: :change_password
  post '/update_password', to: 'users#update_password', as: :update_password
  resources :users, only: %i[new create edit update]
  resource :session, only: [:new]
  resources :sessions, only: %i[create destroy]
end