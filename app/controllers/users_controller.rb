class UsersController < ApplicationController

  def show
#params[:id]でユーザのid返す、User.find(1)のような感じで、値を返す
    @user = User.find(params[:id])
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
end
