class SessionsController < ApplicationController

  def new
  end

  def create
#find_by_email(params[:session][:email].downcaseで、
#データベースの中からsessionで送って来られたemailでユーザの情報を見つける。
    user = User.find_by_email(params[:session][:email].downcase)
#探したユーザの認証パスワードとsessionで送られた認証パスワードが
#一致した場合の処理
    if user && user.authenticate(params[:session][:password])
	sign_in user#app/helpers/sessions_helper.rbのsign_in(user)メソッドから
        redirect_back_or user
    else
    flash.now[:error] = 'Invalid email/password combination' # Not quite right!
    render 'new'
    end
  end

  def destroy
    sign_out
    redirect_to root_url
  end

end
