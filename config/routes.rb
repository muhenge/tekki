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
end
