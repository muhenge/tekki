Rails.application.routes.draw do
  get 'posts/index'
  get 'posts/create'
  get 'posts/show'
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
  # devise_for :users, controllers:{ registrations: 'registrations' } do
  #   get '/users/sign_out' => 'devise/sessions#destroy'
  # end

  resources :skills do
    resources :users
  end
  resources :users, only: [:show], param: :slug
  resources :users, only: %i[show index], param: :slug do 
    resources :posts
    resources :skills, only: %i[create]
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

  resources :relationships, only: [:create, :destroy] do
    resources :users
    resources :posts
  end
  get "/:user_slug/connections", to: "users#user_connections", as: "user_connections"
  get "/current_user_skills", to: "users#current_user_skills"
  root :to => "welcome#home"
end
