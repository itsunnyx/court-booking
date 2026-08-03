class SessionsController < ApplicationController
  skip_before_action :verify_authenticity_token, only: :create

  def create
    auth = request.env['omniauth.auth']
    # The user might be logging in. For now, just save info in session.
    # In Keycloak, roles might be inside auth.extra.raw_info.realm_access.roles
    # Or in auth.info.
    
    session[:user_name] = auth.info.name || auth.info.preferred_username || "SSO User"
    
    # Check for admin role dynamically
    roles = auth.extra&.raw_info&.dig('realm_access', 'roles') || []
    
    # DEBUGGING: Print out the raw info and roles to the rails log
    Rails.logger.info "========= KEYCLOAK DEBUG ========="
    Rails.logger.info "Roles parsed: #{roles.inspect}"
    Rails.logger.info "Raw Info: #{auth.extra&.raw_info&.inspect}"
    Rails.logger.info "=================================="

    admin_roles = ENV.fetch('KEYCLOAK_ADMIN_ROLES', 'admin').split(',')
    session[:is_admin] = (roles & admin_roles).any?

    # Find or create user
    user_name = session[:user_name]
    if user_name.present?
      user = User.find_or_create_by!(name: user_name) do |u|
        u.credit = 0
      end
      session[:user_id] = user.id
      session[:id_token] = auth.credentials&.id_token
    end

    redirect_to root_path, notice: "Successfully logged in via Keycloak"
  end

  def destroy
    id_token = session[:id_token]
    reset_session
    
    if id_token.present?
      logout_url = URI.parse("#{ENV['KEYCLOAK_ISSUER']}/protocol/openid-connect/logout")
      logout_url.query = URI.encode_www_form(
        post_logout_redirect_uri: ENV.fetch('KEYCLOAK_POST_LOGOUT_REDIRECT_URI', 'http://localhost:3000/sign_in'),
        client_id: ENV['KEYCLOAK_CLIENT_ID']
      )
      # Modern Keycloak prefers id_token_hint, but we also pass client_id just in case
      logout_url.query += "&id_token_hint=#{id_token}" if id_token
      redirect_to logout_url.to_s, allow_other_host: true
    else
      redirect_to root_path, notice: "Logged out locally"
    end
  end

  def failure
    redirect_to root_path, alert: "Authentication failed: #{params[:message]}"
  end
end
