module SessionsHelper
#remember meにチェックが入っている場合、
#cookies.permanent[:remember_token] = user.remember_tokenとし
#Userをremember_tokenの値で検索し、ユーザが実在すれば
#ログイン状態にする
  def sign_in(user)
    cookies.permanent[:remember_token] = user.remember_token
    self.current_user = user
#selfは、remember_tokenを持ったユーザを表している
  end
#レイアウトリンク
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

  def sign_out
     self.current_user = nil
     cookies.delete(:remember_token)
  end
end
