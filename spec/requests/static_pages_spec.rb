require 'spec_helper'

describe "Static pages" do
# subject { page }を使うことで、
#
#  it "should have the h1 'Sample App'" do
#    visit root_path
#    page.should have_selector('h1', text: 'Sample App')
#  end
#
#をit { should have_selector('h1', text: 'Sample App') }と省略できる
  subject { page }

  describe "Home page" do
     #before { visit root_path }を使うことで、
     #visit  root_pathを省略できる。
     before { visit root_path }

     it { should have_selector('title', text: full_title('')) }
     it { should have_selector('h1', text: 'Sample App')}
     it { should_not have_selector('title', text: '|Home')}
  end #"Home page"

  describe "Help page" do
     before { visit help_path }

     it { should have_selector('h1', text: 'Help page')}
     it { should have_selector('title', text: full_title('Help')) }
  end #"Help page"

  describe "about us page" do
     before { visit about_path }

     it { should have_selector('h1', text: 'About Us') }
     it { should have_selector('title', text: full_title('About Us')) }
  end #"adout us page"

  describe "Contact page" do
     before { visit contact_path }

     it { should have_selector('h1', text: 'Contact') }
     it { should have_selector('title', text: full_title('Contact')) }
  end #"Contact page"
end #"Static pages"
