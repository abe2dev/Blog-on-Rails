class PostsController < ApplicationController
  before_action :authenticated_user!, except: [:index, :show]

  def index
    @posts = Post.order(created_at: :desc)
  end

  def show
    @post = Post.find params[:id]
    @comment = Comment.new
    @comments = @post.comments.order(created_at: :desc)
  rescue StandardError => e
    redirect_to root_path, alert: e.message
  end

  def destroy
    @post = Post.find params[:id]
    @post.destroy
    redirect_to posts_path, { notice: 'Post deleted successfully', status: 303 }
  rescue StandardError => e
    redirect_to root_path, alert: e.message
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new params.require(:post).permit(:title, :body)
    @post.user = current_user
    if @post.save
      redirect_to post_path(@post) #{ status: 303, notice: 'Post created successfully' }
    else
      render :new, status: 303
    end
  end

  def edit
    @post = Post.find params[:id]
  rescue StandardError => e
    redirect_to root_path, alert: e.message
  end

  def update
    @post = Post.find params[:id]
    if @post.update params.require(:post).permit(:title, :body)
      redirect_to post_path(@post), { status: 303, notice: 'Post updated successfully' }
    else
      render :edit, status: 303
    end
  rescue StandardError => e
    redirect_to posts_path, alert: e.message
  end
end
  