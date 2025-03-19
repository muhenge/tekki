module Api
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:create]
    before_action :set_comment, only: [:destroy]

    def create
      comment = @post.comments.build(comment_params)
      comment.user = current_user

      if comment.save
        render json: { comment:, message: 'Comment created successfully.' }, status: :created
      else
        render json: { error: comment.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def index
      comments = Comment.includes(:user).where(post_id: params[:post_id]).order(created_at: :desc)
      render json: comments, status: :ok
    end

    def destroy
      if @comment.user == current_user
        @comment.destroy
        render json: { message: 'Comment deleted successfully.' }, status: :ok
      else
        render json: { error: 'Not authorized to delete this comment.' }, status: :forbidden
      end
    end

  private

    def set_post
      @post = Post.find(params[:post_id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Post not found' }, status: :not_found
    end

    def set_comment
      @comment = Comment.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Comment not found' }, status: :not_found
    end

    def comment_params
      params.require(:comment).permit(:text)  # Remove `:user_id, :post_id` for security
    end
  end
end
