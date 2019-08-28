class Api::V0::ArticlesController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  
  def index
    articles = Article.all
    render json: articles, each_serializer: Articles::IndexSerializer
  end

  def create
    if current_user.research_group?
      @article = Article.create(article_params.merge(author: current_user))
      attach_pdf      
      render json: { message: 'Article successfully created.' } 
    else
      render json: { error: 'Current user has no permission to create article.' }, status: 422
    end

  end

  private

  def attach_pdf
    if params['pdf'] && params['pdf'].present?
      DecodeService.attach_pdf(params['pdf'], @article.pdf)
    end
  end

  def article_params
    params.require(:article).permit(:title, :body, keys: [:pdf])
  end
end