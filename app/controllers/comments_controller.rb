class CommentsController < ApplicationController
  include QueryFilter
  before_action :authenticate_user!, only: %i[index destroy]
  before_action :set_user
  before_action :authorize_user!, only: %i[index destroy lottery update_winner]
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found

  def index
    set_default_time_interval(1)
    @comments = current_user.comments.with_attached_picture
    @comments = query_by_filter_scope(@comments, filtering_params, :created_at, @default_time_interval)
    @comments = @comments.order(id: :desc).page(params[:page]).per(25)
  end

  def new
    @comment = Comment.new
  end

  def create
    @comment = @user.comments.new(comment_params)
    if max_comments
      flash.now[:notice] = '留言數量已達上限'
      return render :new
    end

    if @comment.save
      redirect_to comment_path(username: @user.username, id: @comment.id)
    else
      render :new
    end
  end

  def show
    @comment = @user.comments.find_by!(id: params[:id])
  end

  def destroy
    @comment = current_user.comments.find_by!(id: params[:id])
    flash[:notice] =  if @comment.destroy
                        '留言已刪除'
                      else
                        '刪除留言失敗'
                      end
    redirect_to comments_path(username: current_user.username)
  end

  def lottery
    set_default_time_interval(1)
    @comments = current_user.comments
    @comments = query_by_filter_scope(@comments, filtering_params)

    if params[:datetime_filter]
      win_number = @comments.pluck(:phone_number).uniq.sample
      if win_number.present?
        win_name = @comments.where(phone_number: win_number).pluck(:name).uniq.join(',')
        @messages = @comments.where(phone_number: win_number).pluck(:message).join(',')
        @comment_ids = @comments.where(phone_number: win_number).ids
        win_number[4..6] = '***'
        @winner = [win_number, win_name]
      end
    end
  end

  def update_winner
    current_user.comments.where(id: params[:comment_ids]).update_all(win: true)
    redirect_to lottery_comments_path, notice: '領獎成功'
  end

  private

  def comment_params
    params.require(:comment).permit(:phone_number, :name, :message, :picture)
  end

  def filtering_params
    params.slice(:phone_number, :name, :win, :datetime_filter)
  end

  def max_comments
    comment_size = @user.comments.size
    (@user.trial? && comment_size > 10) || (@user.silver? && comment_size > 60) || (@user.gold? && comment_size > 120) || (@user.platinum? && comment_size > 200)
  end
end
