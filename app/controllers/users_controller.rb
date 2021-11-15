class UsersController < ApplicationController
  before_action :find_user, only: [:edit, :update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to sign_in_sessions_path, notice: '註冊成功'
    else
      redirect :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params_edit)
      redirect_to root_path, notice: '修改個人資料已修改'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :password, :password_confirmation)
  end

  def user_params_edit
    params.require(:user).permit(:password, :password_confirmation)
  end

  def find_user
    @user = User.find_by!(id: session[ENV["session_name"]])
  rescue ActiveRecord::RecordNotFound
    redirect_to root_path, notice: '查無資料'
  end
end
