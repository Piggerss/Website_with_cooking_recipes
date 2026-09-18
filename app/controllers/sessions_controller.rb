class SessionsController < ApplicationController
  ADMIN_LOGIN = ENV.fetch("ADMIN_LOGIN", "admin")
  ADMIN_PASSWORD = ENV.fetch("ADMIN_PASSWORD", "admin")

  def new
    redirect_to admin_recipes_path if admin_signed_in?
  end

  def create
    if valid_credentials?
      reset_session
      session[:admin_authenticated] = true
      redirect_to admin_recipes_path, notice: "Вы вошли как администратор"
    else
      @login_failed = true
      render :new, status: :unprocessable_content
    end
  end

  def destroy
    reset_session
    redirect_to root_path, notice: "Вы вышли"
  end

  private

  def valid_credentials?
    ActiveSupport::SecurityUtils.secure_compare(params[:login].to_s, ADMIN_LOGIN) &&
      ActiveSupport::SecurityUtils.secure_compare(params[:password].to_s, ADMIN_PASSWORD)
  end
end
