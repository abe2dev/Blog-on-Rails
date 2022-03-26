class CommentsController < ApplicationController
  before_action :authenticated_user!
  before_action :find_comment, only: [:destroy]
  before_action :authorized_user!, only: [:destroy]

  def create
    @post = Post.find params[:post_id]
    @comment = Comment.new params.require(:comment).permit(:body)
    @comment.post = @post
    @comment.user = current_user
    if @comment.save
      redirect_to post_path(@post), status: 303
    else
      @comments = @post.comments.order(created_at: :desc)
      render 'posts/show', status: 303
    end
  rescue StandardError => e
    redirect_to root_path, { alert: e.message, status: 303 }
  end

  def destroy
    @comment.destroy
    redirect_to post_path(@comment.post), status: 303
  rescue StandardError => e
    redirect_to root_path, { alert: e.message, status: 303 }
  end

  private

  def find_comment
    @comment = Comment.find params[:id]
  end

  def authorized_user!
    redirect_to post_path(@comment.post), { status: 303, alert: 'Not authorized' } unless can?(:destroy, @comment)
  end
end