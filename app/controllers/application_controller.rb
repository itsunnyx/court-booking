class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  helper_method :current_user, :is_admin?

  def current_user
    @current_user ||= session[:user_id] ? User.find_by(id: session[:user_id]) : nil
  end

  def is_admin?
    session[:is_admin] || false
  end

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes
end
