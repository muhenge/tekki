require_relative "boot"

require "rails/all"

Bundler.require(*Rails.groups)

module Tekki
  class Application < Rails::Application
    config.load_defaults 8.0

    config.api_only = true

    # Enable cookies & server-side cookie store so controllers can use `cookies`
    config.middleware.use ActionDispatch::Cookies
    config.middleware.use ActionDispatch::Session::CookieStore,
                          key: "_tekki_session"

    # CORS is configured in `config/initializers/cors.rb`
  end
end
