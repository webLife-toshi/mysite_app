require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_selector('h1',    text: 'Sign in') }
    it { should have_selector('title', text: 'Sign in') }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_selector('title', text: 'Sign in') }
      it { should have_selector('div.alert.alert-error', text: 'Invalid') }

      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end #"after visiting another page"
    end #"with invalid information"

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before { sign_in user }

      it { should have_selector('title', text: user.name) }

      it { should have_link('Users',   href: users_path) }
      it { should have_link('Profile', href: user_path(user)) }
      it { should have_link('Settings', href: edit_user_path(user)) }
      it { should have_link('Sign out', href: signout_path) }
      it { should_not have_link('Sign in', href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { should have_link('Sign in') }
      end #"followed by signout"
    end #"with valid information"
  end #"signin page"

  describe "authorization" do

     describe "for non-signed-in users" do
       let(:user) { FactoryGirl.create(:user) }

 	describe "when attempting to visit a protected page" do
	  before do
	     visit edit_user_path(user)
	     fill_in "Email",   with: user.email
	     fill_in "Password", with: user.password
	     click_button "Sign in"
	  end #before do

	  describe "after signing in" do

	     it "should render the desired protected page" do
		page.should have_selector('title', text: 'Edit user')
	     end #"should render the desired protected page"
	  end #"after signing in"
	end #"when attempting to visit a protected page"

	 describe "in the Users controller" do

	   describe "visiting the edit page" do
	     before { visit edit_user_path(user) }
	     it { should have_selector('title', text: 'Sign in') }
	   end #"visiting the edit page"

	   describe "submitting to the update action" do
	     before { put user_path(user) }
		#specifyはitの旧式
	     specify { response.should redirect_to(signin_path) }
	   end #"submitting to the update action"

	   describe "visiting the user index" do
	     before { visit users_path }
	     it { should have_selector('title', text: 'Sign in') }
	   end #"visiting the user index"
	 end #"in the Users controller"

	 describe "in the Microposts controller" do

	   describe "submitting to the create action" do
	     before { post microposts_path }
	     specify{ response.should redirect_to(signin_path) }
	   end #"submitting to the create action"

	   describe "submitting to the destroy action" do
	      before { delete micropost_path(FactoryGirl.create(:micropost)) }
	      specify { response.should redirect_to(signin_path) }
	   end #"submitting to the destroy action"
	 end #"in the Microposts controller"
     end #"for non-signed-in users"

     describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user }

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { should_not have_selector('title', text: full_title('Edit user')) }
      end #"visiting Users#edit page"

      describe "submitting a PUT request to the Users#update action" do
        before { put user_path(wrong_user) }
        specify { response.should redirect_to(root_path) }
      end #"submitting a PUT request to the Users#update action"
     end #"as wrong user"

     describe "as non-admin user" do
	let(:user) { FactoryGirl.create(:user) }
	let(:non_admin) { FactoryGirl.create(:user)}

	before { sign_in non_admin }

	describe "submitting a DELETE request to the Users#destory action" do
	   before { delete user_path(user)}
	   specify { response.should redirect_to(root_path) }
	end #"submitting a DELETE request to the Users#destory action"
     end #"as non-admin user"
  end #"authorization"
end #"Authentication"
