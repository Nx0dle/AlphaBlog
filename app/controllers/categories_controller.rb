# frozen_string_literal: true

class CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :destroy, :edit, :update]
  before_action :require_admin, except: [:show, :index]
  def show
    @articles = @category.articles.paginate(page: params[:page], per_page: 6)
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

  def destroy
    @category.destroy
    redirect_to categories_path
    flash[:notice] = "Category deleted."
  end

  def edit
  end

  def update
    if @category.update(category_params)
      flash[:notice] = "Category name updated."
      redirect_to @category
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def index
    @categories = Category.paginate(page: params[:page], per_page: 12)
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
