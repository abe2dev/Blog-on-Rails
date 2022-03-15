class CommentsController < ApplicationController
    def create
        @post = Post.find params[:post_id]
        @comment = Comment.new params.require(:comment).permit(:body)
        @comment.post = @post
        if @comment.save
            redirect_to post_path(@post)
        else
            @comments = Comment.order(created_at: :desc)
            render 'posts/show', status: 303
        end
    rescue => e
        redirect_to root_path, alert: e.message
    end

    def destroy
        @comment = Comment.find params[:id]
        @comment.destroy
        @post = Post.find params[:post_id]
        redirect_to post_path(@post), status: 303
    rescue => e
        redirect_to root_path, alert: e.message
    end
    
end
