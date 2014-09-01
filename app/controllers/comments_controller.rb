class CommentsController < ApplicationController

  def index
  end
  
  def create
    binding.pry
    @article = Article.find(params[:article_id])
    @comment = @article.comments.create(comment_params)
    redirect_to article_path(@article)
  end
 
  def destroy
    @article = Article.find(params[:article_id])
    @comment = @article.comments.find(params[:id])

    if @comment.user_id == current_user.id || @article.user_id == current_user.id
      @comment.destroy
    end

    redirect_to article_path(@article)
  end
 
  private
    def comment_params
      params.require(:comment).permit(:commenter, :body).merge(user_id: current_user.id)
    end
end