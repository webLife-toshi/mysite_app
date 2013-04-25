module SessionsHelper
#remember meにチェックが入っている場合、
#cookies.permanent[:remember_token] = user.remember_tokenとし
#Userをremember_tokenの値で検索し、ユーザが実在すれば
#ログイン状態にする
#self.curent_userは、自動的にcurrent_user=(user)をよびだす
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
#selfは、remember_tokenを持ったユーザを表している
  end
#レイアウトリンク
#<% if signed_in? %>
  # Links for signed-in users
#<% else %>
  # Links for non-signed-in-users
#<% end %>
#これを!current_user.nil?で定義している
  def signed_in?
    !current_user.nil?
  end

#セッター
  def current_user=(user)
    @current_user = user
  end
#ゲッター

  def current_user
    @current_user ||= User.find_by_remember_token(cookies[:remember_token])
  end
#セッターapp/controllers/users_controller.rb で使われている
  def current_user?(user)
    user == current_user
  end

  def sign_out
     self.current_user = nil
     cookies.delete(:remember_token)
  end
#session[:return_to]かdefaultにリダイレクトする。
  def redirect_back_or(default)
     redirect_to(session[:return_to] || default)
     session.delete(:return_to)
  end
#リクエストページをsession[:return_to]に保存する
  def store_location
     session[:return_to] = request.url
  end
end
