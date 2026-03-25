Rails.application.routes.draw do
  # Swagger UI and API routes (rswag)
  mount Rswag::Ui::Engine => "/api-docs"
  mount Rswag::Api::Engine => "/api-docs"

  devise_for :users,
             path: "",
             path_names: {
               sign_in: "api/auth/login",
               sign_out: "api/auth/logout",
               registration: "api/auth/signup",
               password: "api/auth/password"
               # confirmations: 'api/auth/confirmations'
             },
             controllers: {
               sessions: "api/auth/sessions",
               registrations: "api/auth/registrations",
               passwords: "api/auth/passwords",
               omniauth_callbacks: "api/auth/omniauth_callbacks"
             }

  # OmniAuth routes for Google, Microsoft, Apple
  namespace :api, defaults: { format: :json } do
    namespace :auth do
      get "google_oauth2/callback", to: "omniauth_callbacks#google_oauth2"
      get "microsoft_office365/callback", to: "omniauth_callbacks#microsoft_office365"
      post "apple/callback", to: "omniauth_callbacks#apple"
    end
  end

  namespace :api, defaults: { format: :json } do
    namespace :auth do
      post :magic_login, to: "magic_logins#show"
      post "refresh", to: "tokens#create"
    end
    get "careers/index"
    resources :skills do
      resources :users
    end
    post "/skills", to: "skills#create"

    get "auth/current_user", to: "auth/auth_status#check"

    resources :users, only: [:show], param: :slug
    resources :users, only: %i[show index], param: :slug do
      resources :posts
      resources :skills, only: %i[show]
    end

    resources :posts, only: [:create]
    get "relationships/create"
    get "relationships/destroy"
    get "transit/home"

    resources :comments do
      resources :users
      resources :posts
    end

    authenticated :user do
      root "posts#index", as: :authenticated_root
    end

    resources :users, only: [:index]

    resources :posts do
      resources :users
      resources :careers
      resources :comments
      resources :skills
      member { put "like" => "posts#vote" }
    end

    resources :careers, only: [:index]

    resources :relationships, only: %i[create destroy] do
      resources :users
      resources :posts
    end
    get "/:user_slug/connections",
        to: "users#user_connections",
        as: "user_connections"
    get "/current_user_skills", to: "users#current_user_skills"
    root to: "welcome#home"
  end
end
