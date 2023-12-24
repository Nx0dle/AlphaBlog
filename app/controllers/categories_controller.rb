# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show]
  before_action :require_admin, except: [:show, :index]
  def show
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      flash[:notice] = "Category was created successfully."
      redirect_to @category
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 9)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def require_admin
    unless logged_in? && current_user.admin?
      flash[:alert] = "Only admins can perform that action."
      redirect_to categories_path
    end
  end
end
