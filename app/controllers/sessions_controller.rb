class SessionsController < ApplicationController
  def new
    redirect_to comments_path(current_user.username)if current_user
  end

  def create
    @user = User.find_by(username: params[:username])
    if @user && @user.authenticate(params[:password])
      session[ENV['session_name']] = @user.id
      redirect_to comments_path(username: @user.username), notice: '已登入'
    else
      redirect_to sign_in_sessions_path, notice: '帳號或密碼錯誤'
    end
  end

  def destroy
    session[ENV['session_name']] = nil
    redirect_to sign_in_sessions_path, notice: '已登出'
  end
end
