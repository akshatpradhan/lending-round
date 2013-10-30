require 'spec_helper'

feature "User authenticates with dwolla" do

  given!(:user) {create(:user)}

  background do
    OmniAuth.config.test_mode = true
  end

  describe "for registered users" do
    background do
      OmniAuth.config.add_mock :dwolla, {
        uid: user.uid,
        provider: user.provider,
        info: {
          name: user.name,
          email: user.email
        }
      }
    end

    scenario "registered user can sign in with dwolla" do
      visit signin_path
      page.should_not have_content "Please enter your email address"
      page.should have_content "Signed in!"
      page.current_path.should == root_path
    end
  end

  scenario "unregistered user should fill in his email when blank" do
    visit signin_path
    page.should have_content "Please enter your email address"
    fill_in "Email", with: "test@test.com"
    click_button "Sign in"
    page.should have_content "Signed in!"
    page.current_path.should == root_path
  end
end
