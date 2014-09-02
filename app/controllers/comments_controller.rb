class CommentsController < ApplicationController

  before_filter :correct_user_or_parent_or_admin, :only => [:index, :create, :destroy]

  def index
    @lesson = Lesson.find(params[:lesson_id])
    @title = "Comments for #{@lesson.name}"
  end
  
  def create
    @lesson = Lesson.find(params[:lesson_id])
    @comment = @lesson.comments.create(comment_params)
    redirect_to lesson_comments_path(@lesson)
  end
 
  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy if @comment.user_id == current_user.id 
    redirect_to lesson_comments_path(@comment.lesson_id)
  end
 
  private

    def comment_params
      params.require(:comment).permit(:commenter, :body).merge(user_id: current_user.id)
    end

    def correct_user_or_parent_or_admin
      @user = Lesson.find(params[:lesson_id]).user
      @parent = @user.parent
      unless current_user?(@user) || current_user.admin? || current_user?(@parent)
        flash[:alert] = "You are not authorised to view this page."
        redirect_to(root_path) 
      end
    end

end