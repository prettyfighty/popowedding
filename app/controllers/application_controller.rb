class ApplicationController < ActionController::Base
  helper_method :current_user, :user_signed_in?
  before_action do
    ActiveStorage::Current.host = request.base_url if Rails.env.development?
  end

  private
  def record_not_found
    return redirect_to comments_path(current_user.username), notice: '查無資料' if current_user
    render plain: '查無資料', status: 404
  end

  def current_user
    User.find_by(id: session[ENV['session_name']])
  end

  def user_signed_in?
    session[ENV['session_name']]
  end

  def authenticate_user!
    redirect_to sign_in_sessions_path, notice: '請先登入' if session[ENV['session_name']] == nil
  end

  def authorize_user!
    redirect_to comments_path(current_user.username), notice: '您並無權限' if @user != current_user
  end

  def set_user
    @user = User.find_by!(username: params[:username])
  end
end
