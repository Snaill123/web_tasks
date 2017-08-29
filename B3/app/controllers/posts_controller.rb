class PostsController < ApplicationController
  include UsersHelper
  before_action :require_login, except: [:index, :show]
  def index
    @posts=Post.order(created_at: :desc)
  end

  def show
    @post = Post.find(params[:id])
    @comment = Comment.new
  end

  def admin_index
  	@posts=Post.order(created_at: :desc)
  end

  def create
    @post = Post.new(post_params)
    if @post.save
      redirect_to show_post_path(@post)
    else
      render 'create'
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:post][:id])
    if @post.update(post_params)
      flash[:success] = "Update post with id: #{@post.id}  successfully"
      redirect_to admin_posts_path
    else
      # 更新失败则显示更新页面，同时会显示相关的错误信息
      render 'edit'
    end

  end

  def destroy
    post = Post.find(params[:id])
    post.destroy
    # 同时 flash 一条删除成功的信息
    flash[:danger] = "Dlete post with id: #{post.id} successfully"
    redirect_to admin_posts_path
  end

  def new
    @post = Post.new
  end

  private
  # 允许params[:post][:title] 和 params[:post][:text] 被访问
  def post_params
    params.require(:post).permit(:title, :text)
  end
end
