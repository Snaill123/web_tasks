class CommentsController < ApplicationController
  include UsersHelper
  before_action :require_login, except: [:create]

  def create
  	@post = Post.find(params[:id])
  	@comment = @post.comments.create(comment_params)
  	redirect_to show_post_path(@post)
  end

  def destroy
  	@comment = Comment.find(params[:id])
  	@post = @comment.post
  	@comment.destroy
  	redirect_to show_post_path(@post)
  end
  
  private
  def comment_params
    params.require(:comment).permit(:author, :content)
  end
end
