require 'spec_helper'

describe "UserPages" do

  subject { page }

  describe "index" do
    
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
     sign_in user
      visit users_path
    end #before do
    
    it { should have_selector('title', text: 'All users') }
    it { should have_selector('h1',    text: 'All users') }

    describe "pagination" do

     before(:all) { 30.times { FactoryGirl.create(:user) } }
     after(:all) { User.delete_all }

     it { should have_selector('div.pagination') }

     it "should list each user" do
	User.paginate(page: 1).each do |user|
	  page.should have_selector('li', text: user.name )
	end #User.paginate(page: 1).each do |user|
     end #"should list each user"
    end #"pagination"

    describe "delete links" do

	it { should_not have_link('delete') }

	describe "as an admin user" do
	   let(:admin) { FactoryGirl.create(:admin) }
	   before do
	      sign_in admin
	      visit users_path
	   end #before do
	   it { should have_link('delete', href: user_path(User.first)) }
	   it "should be able to delete another user" do
		expect { click_link('delete') }.to change(User, :count).by(-1)
	   end #"should be able to delete another user"
	   it { should_not have_link('delete', href: user_path(admin)) }
	end #"as an admin user"
    end #"delete links"
  end #"index"

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

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
       sign_in user
       visit edit_user_path(user)
    end #before do

    describe "page" do
      it { should have_selector('h1',    text: "Update your profile") }
      it { should have_selector('title', text: "Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end #"page"

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end #"with invalid information"

    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end #before do

      it { should have_selector('title', text: new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { user.reload.name.should  == new_name }
      specify { user.reload.email.should == new_email }
    end #"with valid information"
  end #"edit"
end #"UserPages"
