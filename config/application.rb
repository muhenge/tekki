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

    # Enable CORS and allow credentials (keep your existing cors.rb if present)
    config.middleware.insert_before 0, Rack::Cors do
      allow do
        origins ENV.fetch("CORS_ORIGINS", "http://localhost:3000")
        resource "*",
                 headers: :any,
                 methods: %i[get post put patch delete options head],
                 credentials: true
      end
    end
  end
end
