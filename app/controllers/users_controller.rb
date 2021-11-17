class UsersController < ApplicationController
  http_basic_authenticate_with name: ENV['basic_authenticate_name'], password: ENV['basic_authenticate_password']

  before_action :set_user, :authenticate_user!, :authorize_user!, only: %i[edit update]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to sign_in_sessions_path, notice: '註冊成功'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(bride: params[:user][:bride],
                    bridegroom: params[:user][:bridegroom],
                    picture: params[:user][:picture])
      redirect_to comments_path(current_user.username), notice: '新人資料更新完成'
    else
      render :edit
    end
  end

  private

  def user_params
    params.require(:user).permit(:bride, :bridegroom, :username, :password, :password_confirmation, :picture)
  end
end
