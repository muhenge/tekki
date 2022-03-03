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
end
