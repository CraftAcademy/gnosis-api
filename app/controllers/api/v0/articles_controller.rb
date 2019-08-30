class Api::V0::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  
  def index
    if params[:city]
      articles = Article.where(city: params[:city])
    else
      articles = Article.all
    end
    render json: articles, each_serializer: Articles::IndexSerializer 
  end


  def create
    if current_user.research_group?
      Article.create(article_params.merge(author: current_user))
      render json: {message: 'Article successfully created.'} 
    else
      render json: { error: 'Current user has no permission to create article.' }, status: 422
    end
  end

  private

  def article_params
    params.require(:article).permit(:title, :body)
  end
end