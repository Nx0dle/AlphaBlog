class PagesController < ApplicationController
  def home
    @articles = Article.paginate(page: params[:page], per_page: 9)
    redirect_to articles_path if logged_in?
  end

  def about

  end
end
