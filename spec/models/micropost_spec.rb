require 'spec_helper'

describe Micropost do

  let(:user) { FactoryGirl.create(:user) }
#user.microposts.buildを宣言することで、自動的にuser_idに結びつく
  before { @micropost = user.microposts.build(content: "Lorem ipsum") }

  subject { @micropost }

  it { should respond_to(:content) }
  it { should respond_to(:user_id) }
  its(:user) { should == user }

  it { should be_valid }

  describe "when user_id is not present" do
     before { @micropost.user_id = nil }
     it { should_not be_valid }
  end #"when user_id is not present"

  describe "accessible attributes" do
    it "should not allow access to user_id" do
      expect do
	Micropost.new(user_id: user.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end #"should not allow access to user_id"
  end #"accessible attributes"

  describe "when user_id is not present" do
     before { @micropost.user_id = nil }
     it { should_not be_valid }
  end #"when user_id is not present"

  describe "when user_id is not present" do
     before { @micropost.user_id = nil }
     it { should_not be_valid }
  end #"when user_id is not present"

  describe "with blank content" do
     before { @micropost.content = " " }
     it { should_not be_valid }
  end #"with blank content"

  describe "with contnet that is too long" do
     before  { @micropost.content = "a" * 141 }
     it { should_not be_valid }
  end #"with contnet that is too long"
end
