# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show, :destroy, :edit, :update]
  before_action :require_logout, only: [:new, :create]
  before_action :require_same_user, only: [:destroy, :edit, :update]

  def index
    @users = User.paginate(page: params[:page], per_page: 12)
  end

  def show
    @articles = @user.articles.paginate(page: params[:page], per_page: 6)
  end
  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = "Welcome to Alpha #{@user.username}, you have successfully signed up!"
      redirect_to root_path
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:notice] = "User information updated."
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def destroy
    @user.destroy
    session[:user_id] = nil if @user == current_user
    redirect_to root_path
    flash[:notice] = "User deleted."
  end

  private
  def user_params
    params.require(:user).permit(:username, :email, :password)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def require_logout
    if current_user != @user
      flash[:alert] = "You need to logout to perform that action."
      redirect_to current_user
    end
  end

  def require_same_user
    if current_user != @user && !current_user.admin?
      flash[:alert] = "You can't perform that action."
      redirect_to current_user
    end
  end
end