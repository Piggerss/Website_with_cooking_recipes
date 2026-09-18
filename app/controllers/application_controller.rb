class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  stale_when_importmap_changes

  helper_method :admin_signed_in?

  private

  def admin_signed_in?
    session[:admin_authenticated] == true
  end

  def require_admin
    redirect_to login_path unless admin_signed_in?
  end
end
