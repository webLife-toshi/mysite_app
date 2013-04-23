require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "signup page" do
     before { visit signup_path }

    it { should have_selector('h1', text: 'Sign up') }
    it { should have_selector('title', text: full_title('Sign up')) }
  end #"signup page"

  describe "profile page" do
#:userにfactorygirlで定義したfactory :userを保存する
     let(:user) { FactoryGirl.create(:user) }
     before { visit user_path(user) }#showpageを準備する

     it { should have_selector('h1',    text: user.name) }
     it { should have_selector('title', text: user.name) }
  end #"profile page"

  describe "signup" do

     before { visit signup_path }

     let(:submit) { "Create my account" }

     describe "with invalid information" do
	it "should not create a user" do
#「expect」のブロックの中でテストする処理を行い、
#その処理が行なった結果起きる変化を「change」内で記述しています
#ここでは、値がない場合でsubmitが押された場合
#Userのカウントをしないという処理になる
#"Create my account"(submit)というvalue値を持つボタンをクリック。
#後は、have_contentでデータが含まれているかどうかチェックしているだけですね。
	  expect { click_button submit }.not_to change(User,:count)
	end #"should not create a user"

	describe "after submission" do
	  before { click_button submit }

	  it { should have_selector('title', text: 'Sign up') }
          it { should have_content('error') }
	end #"after submission"
     end #"with invalid information"

     describe "with valid information" do
#ラベル名「Name」に紐づくフィールドに値「Example User」を
#挿入するということをやっています。
	before do
	  fill_in "Name",         with: "Example User"
          fill_in "Email",        with: "user@example.com"
          fill_in "Password",     with: "foobar"
          fill_in "Confirmation", with: "foobar"
	end #before do

	it "should create a user" do
	  expect { click_button submit }.to change( User, :count)
	end #"should create a user"

	describe "after saving the user" do
          before { click_button submit }
          let(:user) { User.find_by_email('user@example.com') }

          it { should have_selector('title', text: user.name) }
         it { should have_selector('div.alert.alert-success', text: 'Welcome') }
	 it { should have_link('Sign out') }
      end #"after saving the user"
     end #"with valid information"
  end #"signup"
end #"UserPages"
