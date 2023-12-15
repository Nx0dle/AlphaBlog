# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :set_user, only: [:show]
  before_action :require_logout, only: [:new, :create]

  def index
    @users = User.paginate(page: params[:page], per_page: 3)
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
end