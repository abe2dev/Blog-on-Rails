class PostsController < ApplicationController
  before_action :authenticated_user!, except: %i[index show]
  before_action :find_post, except: %i[index new create]
  before_action :authorized_user!, only: %i[edit update destroy]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :desc)
  rescue StandardError => e
    redirect_to root_path, {alert: e.message, status: 303}
  end

  def destroy
    @post.destroy
    redirect_to root_path, { notice: 'Post deleted successfully', status: 303 }
  rescue StandardError => e
    redirect_to root_path, {alert: e.message, status: 303}
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new params.require(:post).permit(:title, :body)
    @post.user = current_user
    if @post.save
      redirect_to post_path(@post) # { status: 303, notice: 'Post created successfully' }
    else
      render :new, status: 303
    end
  end

  def edit
  rescue StandardError => e
    redirect_to root_path, {alert: e.message, status: 303}
  end

  def update
    if @post.update params.require(:post).permit(:title, :body)
      redirect_to post_path(@post), { status: 303, notice: 'Post updated successfully' }
    else
      render :edit, status: 303
    end
  rescue StandardError => e
    redirect_to root_path, {alert: e.message, status: 303}
  end

  private

  def find_post
    @post = Post.find params[:id]
  end

  def authorized_user!
    redirect_to post_path(@post), { status: 303, alert: 'Not authorized' } unless can?(:crud, @post)
  end
end
