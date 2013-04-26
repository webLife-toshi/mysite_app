class UsersController < ApplicationController
#  before_filter :signed_in_user, only: [:index, :edit, :update, :destroy]
  before_filter :correct_user,   only: [:edit, :update]
  before_filter :admin_user,     only: :destroy

  def show
#params[:id]でユーザのid返す、User.find(1)のような感じで、値を返す
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
  end

  def new
#form_forで受け取った値をUser.newで型を作って値を入れる。受け皿みたいなもの
    @user = User.new
  end

  def create
#params[:user]で受け取った値の連想配列を取得
#@user = User.new(params[:user])
#と
#@user = User.new(name: "Foo Bar", email: "foo@invalid",
#                 password: "foo", password_confirmation: "bar")
#同じ意味

    @user = User.new(params[:user])
    if @user.save
#With the sign_in method from Section 8.2, getting this test to pass by
#actually signing in the user is easy: just add sign_in @user right after
#saving the user to the database
      sign_in @user 
#flash[:success]は、ユーザが作成された時に現れる。
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user #redirect to the user show page
    else
      render 'new'
    end
  end

  def index
    @users = User.paginate( page: params[:page])
  end

  def edit
     @user = User.find(params[:id])
  end

  def update
#ここで、ユーザ情報を探す
     @user = User.find(params[:id])
#もし、ユーザが存在したら、@user.update_attributes(params[:user])
#はtrueを返して、ユーザ情報の変更ができるようになる
     if @user.update_attributes(params[:user])
       flash[:success] = "Profile updated"
      sign_in @user
      redirect_to @user
     else
       render 'edit'
     end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_url
  end

  private

#unless signed_in?でsigninされてない場合、
#store_locationを実行してリダイレクトする

#    def signed_in_user
#	unless signed_in?
#	store_location
#	redirect_to signin_url, notice: "Please sign in"
#	end
#    end
#unless current_user?(@user)がない場合、トップページにいく
    def correct_user
	@user = User.find(params[:id])
	redirect_to(root_path) unless current_user?(@user)
    end

    def admin_user
      redirect_to(root_path) unless current_user.admin?
    end
end
