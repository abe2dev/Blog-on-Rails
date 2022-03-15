class CommentsController < ApplicationController
    def create
        @post = Post.find params[:post_id]
        @comment = Comment.new params.require(:comment).permit(:body)
        @comment.post = @post
        if @comment.save
            redirect_to post_path(@post)
        else
            @comments = Comment.all
            render 'posts/show', status: 303
        end
    end

    def destroy
        @comment = Comment.find params[:id]
        @comment.destroy
        @post = Post.find params[:post_id]
        redirect_to post_path(@post), status: 303
    end
end
