class UsersController < ApplicationController
  before_action :authenticated_user!, except: %i[new create]
  before_action :find_user, only: %i[edit update]
  before_action :authorized_user!, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(:name, :email, :password, :password_confirmation)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, status: 303
    else
      render :new, status: 303
    end
  end

  def edit; end

  def update
    if @user.update params.require(:user).permit(:name, :email, :password, :password_confirmation)
      redirect_to root_path, status: 303
    else
      flash.alert = 'Update failed, please try again'
      render :edit, status: 303
    end
  end

  def change_password
    @user = User.new
  end

  def update_password
    current_password = params[:current_password]
    new_password = params[:new_password]
    new_password_confirmation = params[:new_password_confirmation]
    user = User.find_by_id current_user.id
    if user&.authenticate current_password
      if new_password == current_password
        flash.alert = 'New password must be different'
        render :change_password, status: 303
      elsif new_password == new_password_confirmation
        if user.update password: new_password
          redirect_to root_path, { notice: 'Password updated', status: 303 }
        else
          flash.alert = 'Password update failed, try again'
          render :change_password, status: 303
        end
      else
        flash.alert = 'New password confirmation does not match'
        render :change_password, status: 303
      end
    else
      flash.alert = 'Current password does not match'
      render :change_password, status: 303
    end
  end

  private

  def find_user
    @user = User.find_by_id params[:id]
  end

  def authorized_user!
    redirect_to root_path, { status: 303, alert: 'Not authorized' } unless can?(:crud, @user)
  end
end