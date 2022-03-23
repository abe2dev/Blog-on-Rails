class UsersController < ApplicationController
  before_action :authenticated_user!, only: [:edit, :update]
  def new
    @user = User.new
  end

  def create
    @user = User.new params.require(:user).permit(:name, :email, :password, :password_confirmation)
    if @user.save
      redirect_to root_path, status: 303
    else
      render :new, status: 303 
    end
  end

  def edit
    @user = User.find_by_id params[:id]
  end

  def update
    @user = User.find_by_id params[:id]
    if @user.update params.require(:user).permit(:name, :email, :password, :password_confirmation)
      redirect_to root_path, status: 303
    else
      flash.alert = "Update failed, please try again"
      render :edit, status: 303
    end
  end
end
