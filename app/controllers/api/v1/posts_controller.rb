module Api
  module V1
    class PostsController < ApplicationController
      before_action :authenticate_request!
      before_action :set_post, only: [:show, :update, :destroy]

      def index
        @posts = Post.all.order("created_at DESC")
      end

      def show
      end

      def create
        @post = current_user.posts.create(post_params)
        if @post.save
          render :show, status: :created
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def update
        return unless @post.user_is_author?(current_user.id)
        if @post.update(post_params)
          render :show, status: :ok
        else
          render json: @post.errors, status: :unprocessable_entity
        end
      end

      def destroy
        return unless @post.user_is_author?(current_user.id)
        @post.destroy
      end

      private

      def post_params
        params.require(:post).permit(:title, :body, tags_attributes: %i[title])
      end

      def set_post
        @post = Post.find(params[:id])
      end

    end
  end
end
