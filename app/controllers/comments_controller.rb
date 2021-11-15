class CommentsController < ApplicationController
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :set_user

  def index
    @q = current_user.comments.ransack(params[:q])
    @comments = @q.result(distinct: true).order(created_at: :asc).page(params[:page]).per(25)
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @user.comments.new(comment_params)

    if @comment.save
      redirect_to comment_path(username: @user.username, id: @comment.id)
    else
      render :new
    end
  end

  def show
    @comment = @user.comments.find_by(id: params[:id])
  end

  def destroy
    @comment = current_user.comments.find_by!(id: params[:id])
    @comment.destroy if @user && @user == current_user
    redirect_to comments_path(username: @user.username), notice: '留言已刪除'
  rescue ActiveRecord::RecordNotFound
    redirect_to comments_path(username: @user.username), notice: '刪除留言失敗'
  end

  private

  def comment_params
    params.require(:comment).permit(:phone_number, :name, :message)
  end

  def set_user
    @user = User.find_by!(username: params[:username])
  rescue ActiveRecord::RecordNotFound
    render plain: '查無資料'
  end
end
