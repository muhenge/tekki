# Ensure URL helpers have a default host for ActiveStorage URLs
Rails.application.routes.default_url_options[:host] ||= ENV['HOST'] || 'localhost:3002'
