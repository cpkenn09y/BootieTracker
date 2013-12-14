Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dbc, ENV['OAUTH_TOKEN'], ENV['OAUTH_SECRET']
end