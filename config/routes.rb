Rails.application.routes.draw do
  

  devise_for :users,
  path: '',
  path_names: {
    sign_in: 'api/login',
    sign_out: 'api/logout',
    registration: 'api/signup'
  },
  controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  resources :posts, only: [:create]
  get 'relationships/create'
  get 'relationships/destroy'
  get 'transit/home'

  namespace :api, defaults: { format: :json } do
    get 'careers/index'
  resources :skills do
    resources :users
  end
  post '/skills', to: 'skills#create'
  
  resources :users, only: [:show], param: :slug
  resources :users, only: %i[show index], param: :slug do 
    resources :posts
    resources :skills, only: %i[show]
  end

  resources :comments do 
    resources :users
    resources :posts
  end

  authenticated :user do
    root 'posts#index', as: :authenticated_root
  end

  resources :users, only: [:index]

  resources :posts do
    resources :users
    resources :careers
    resources :comments
    resources :skills
    member do
      put "like" => "posts#vote"
    end
  end

  resources :careers, only: [:index]

  resources :relationships, only: [:create, :destroy] do
    resources :users
    resources :posts
  end
  get "/:user_slug/connections", to: "users#user_connections", as: "user_connections"
  get "/current_user_skills", to: "users#current_user_skills"
  root :to => "welcome#home"
  end

  
end
