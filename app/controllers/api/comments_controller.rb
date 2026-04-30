module Api
  class CommentsController < ApplicationController
    before_action :authenticate_user!
    before_action :set_post, only: [:create, :index]
    before_action :set_comment, only: [:update, :destroy]

    def create
      comment = @post.comments.build(comment_params)
      comment.user = current_user

      if comment.save
        render json: { 
          comment: comment.as_json(include: { user: { only: [:id, :username, :slug] } }), 
          message: 'Comment created successfully.' 
        }, status: :created
      else
        render json: { error: comment.errors.full_messages.join(', ') }, status: :unprocessable_entity
      end
    end

    def update
      if @comment.user == current_user
        if @comment.update(comment_params)
          render json: { 
            comment: @comment.as_json(include: { user: { only: [:id, :username, :slug] } }), 
            message: 'Comment updated successfully.' 
          }, status: :ok
        else
          render json: { error: @comment.errors.full_messages.join(', ') }, status: :unprocessable_entity
        end
      else
        render json: { error: 'Not authorized to edit this comment.' }, status: :forbidden
      end
    end

    def index
      comments = @post ? @post.comments.includes(:user) : Comment.includes(:user)
      comments = comments.order(created_at: :desc)
      render json: comments, author: comments.map(&:user), status: :ok
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
      post_identifier = params[:post_slug] || params[:post_id]

      if post_identifier
        @post = Post.friendly.find(post_identifier)
      elsif action_name == 'create'
        render json: { error: 'Post not found' }, status: :not_found
      end
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
