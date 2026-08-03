Rails.application.config.middleware.use OmniAuth::Builder do
  provider :openid_connect,
           name: :keycloak,
           issuer: ENV['KEYCLOAK_ISSUER'],
           discovery: true,
           client_options: {
             identifier: ENV['KEYCLOAK_CLIENT_ID'],
             secret: ENV['KEYCLOAK_CLIENT_SECRET'],
             redirect_uri: ENV['KEYCLOAK_REDIRECT_URI']
           },
           response_type: :code,
           scope: [:openid, :profile, :email],
           post_logout_redirect_uri: ENV['KEYCLOAK_POST_LOGOUT_REDIRECT_URI']
end

OmniAuth.config.allowed_request_methods = %i[post get]
