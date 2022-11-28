class ArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    articles = Article.all.includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show


    session[:page_views] ||= 0
    session[:page_views] += 1
    # if the current value is zero (0) increment the page_views by one (1)


    if session[:page_views] <= 3
      # if the current value is less than three (3) render the articles
      article = Article.find(params[:id])
      render json: article
    else
      # else if the current value is greater than three (3) render an error messeage of unauthorized due to maximum reach of pages that can be viewed

      render json: { error: "Maximum pageview limit reached" }, status: :unauthorized
      
    end
  end

  private

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
