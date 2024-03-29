# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe User do

  before do
 @user = User.new(name: "Example User", email: "user@example.com",
		password: "foobar", password_confirmation: "foobar")
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:remember_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
#  it { should respond_to(:authenticate) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end #before do

    it { should be_admin }
  end #"with admin attribute set to 'true'"

  describe "when name is not present" do
     before { @user.name = " " }
     it { should_not be_valid }
  end #"when name is not present"

  describe "when email is not present" do
     before { @user.email = " " }
     it { should_not be_valid }
  end #"when email is not present"

  describe "when name is too long" do
     before { @user.name = "a" * 51 }
     it { should_not be_valid }
  end #"when name is too long"

  describe "when email format is invalid" do
     it "should be invalid" do
	addresses =%w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
	addresses.each do |invalid_address|
	  @user.email = invalid_address
	  @user.should_not be_valid
	end #addresses.each do |invalid_address|
    end #"should be invalid"
  end #"when email format is invalid"

  describe "when email format is valid" do
     it "should be valid" do
	addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
	addresses.each do |valid_address|
	  @user.email = valid_address
	  @user.should be_valid
	end #addresses.each do |valid_address|
     end #"should be valid"
  end #"when email format is valid"

 describe "when email address is already taken" do
  before do
    user_with_same_email = @user.dup
    user_with_same_email.email = @user.email.upcase
    user_with_same_email.save
  end #before do

   it { should_not be_valid }
 end #"when email address is already taken"

  describe "email address with mixed case" do
     let(:mixed_case_email) { "Foo@ExAMPle.Com" }

     it "should be saved as all lower-case" do
	@user.email = mixed_case_email
	@user.save
	@user.reload.email.should == mixed_case_email.downcase
     end #"should be saved as all lower-case"
  end #"email address with mixed case"

  describe "when password is not present" do
     before { @user.password = @user.password_confirmation = " " }
     it { should_not be_valid }
  end #"when password is not present"

  describe "when password doesn't match confirmation" do
     before { @user.password_confirmation = "mismatch" }
     it { should_not be_valid }
  end #"when password doesn't match confirmation"

  describe "when password confirmation is nil" do
     before { @user.password_confirmation = nil }
     it { should_not be_valid }
  end #"when password confirmation is nil"

  describe "return value of authenticate method" do
     before { @user.save }
     let(:found_user) { User.find_by_email(@user.email) }

     describe "with valid password" do
        it { should == found_user.authenticate(@user.password) }
     end #"with valid password"

     describe "with invalid password" do
        let(:user_for_invalid_password) { found_user.authenticate("invalid")}
        it { should_not == user_for_invalid_password }
        specify { user_for_invalid_password.should be_false }
     end #"with invalid password"
  end #"return value of authenticate method"

  describe "remember token" do
    before { @user.save }
#it { @user.remember_token.should_not be_blank }と同じ意味
    its(:remember_token) { should_not be_blank }
  end #"remember token"

  describe "micropost associations" do

     before { @user.save }
     let!(:older_micropost) do
       FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
     end #let!(:older_micropost)
     let!(:newer_micropost) do
       FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
     end #let!(:newer_micropost)

     it "should destroy associated mieroposts" do
       microposts = @user.microposts.dup
       @user.destroy
       microposts.should_not be_empty
       microposts.each do |micropost|
	Micropost.find_by_id(micropost.id).should be_nil
       end #microposts.each do |micropost|
     end #"should destroy associated mieroposts"

     it "should have the right microposts in the right order" do
       @user.microposts.should == [newer_micropost, older_micropost]
     end #"should have the right microposts in the right order"

     describe "status" do
       let(:unfollowed_post)do
	FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
       end #"status"

       its(:feed) { should include(newer_micropost) }
       its(:feed) { should include(older_micropost) }
       its(:feed) { should_not include(unfollowed_post) }
     end #"status"
  end #"micropost associations"
end
