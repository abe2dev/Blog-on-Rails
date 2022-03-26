class ApplicationController < ActionController::Base

  private
  def authenticated_user!
    redirect_to new_session_path, {alert: "Please sign in first", status: 303} unless user_signed_in?
  end
  helper_method :authenticated_user! 

  def user_signed_in?
    current_user.present?
  end
  helper_method :user_signed_in?
  
  def current_user
    @current_user ||= User.find_by_id session[:user_id]
  end
  helper_method :current_user
end
