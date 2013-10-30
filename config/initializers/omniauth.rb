Rails.application.config.middleware.use OmniAuth::Builder do
  provider :dwolla, ENV['OMNIAUTH_PROVIDER_KEY'], ENV['OMNIAUTH_PROVIDER_SECRET'], :scope => 'accountinfofull|send|request', :provider_ignores_state => true
end
