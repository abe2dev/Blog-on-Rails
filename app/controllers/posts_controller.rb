class PostsController < ApplicationController
    def index 
        @posts = Post.all
    end
    
    def show
        @post = Post.find params[:id]
        @comment = Comment.new
        @comments = Comment.all
    rescue => e
        redirect_to posts_path, alert: e.message 
    end 

    def destroy
        @post = Post.find params[:id]
        @post.destroy
        redirect_to posts_path, { notice: "Post deleted successfully", status: 303 }
    rescue => e
        redirect_to posts_path, alert: e.message
    end 

    def new
        @post = Post.new
    end

    def create
        @post = Post.new params.require(:post).permit(:title, :body)
        if @post.save
            redirect_to post_path(@post)
        else
            render :new, status: 303
        end
    end

    def edit
        @post = Post.find params[:id]
    rescue => e
        redirect_to posts_path, alert: e.message
    end

    def update
        @post = Post.find params[:id]
        if @post.update params.require(:post).permit(:title, :body)
            redirect_to post_path(@post), { notice: "Post updated successfully", status: 303 }
        else
            render :edit, status:303
        end
    rescue => e
        redirect_to posts_path, alert: e.message
    end
end
