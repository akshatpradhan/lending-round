require "spec_helper"

feature "Lender creates a loan" do

  #A.
  #Given I’m (inviter) on http://www.lendinground.com/notes/new
  #When I enter in all the loan information and
  #When I enter in both email addresses and
  #When I click Checkout with Dwolla
  #Then an email should be sent to !current_user.email(invitee) with a link to <a href="/signin">Create an account to see the loan</a>

  #B.
  #Given I’m(invitee) viewing my email
  #When I click “Create an account to see the loan” and
  #When I go through the process of creating an account
  #Then I should be redirected to notes/:id

  given!(:user) {create(:user)}
  given!(:borrower_email) {"terrynichols@gmail.com"}

  background do
    OmniAuth.config.test_mode = true
    OmniAuth.config.add_mock :dwolla, {
      uid: user.uid,
      provider: user.provider,
      info: {
        name: user.name,
        email: user.email
      }
    }
    visit root_path
    click_on "Login"
    visit new_note_path
    fill_in "note_amount",     with: 6000
    fill_in "note_rate",       with: 11.0
    fill_in "note_term",       with: 36
    fill_in "note_start_date", with: "2013/10/27"

    fill_in "note_lender_email",   with: user.email
    fill_in "note_borrower_email", with: borrower_email
    click_button "Checkout with Dwolla!"
    visit signout_path
  end

  scenario "borrower receives an invitation email" do
    borrower = User.where(email: borrower_email).first
    mail = ActionMailer::Base.deliveries.last
    mail.to.should include borrower.email
  end

  describe "bla" do
    background do
      OmniAuth.config.test_mode = true
      OmniAuth.config.add_mock :dwolla, {
        uid: "100004721472442",
        provider: "dwolla",
        info: {
          name: "Don borrower",
          email: borrower_email
        }
      }
    end
    scenario "borrower accepts invitation to see the loan" do
      borrower = User.where(email: borrower_email).first
      visit accept_user_invitation_path(invitation_token: borrower.invitation_token)
      print borrower.inspect
      page.should have_content /Successfully authenticated from Dwolla account/i
      page.should have_content(/Loans you have been invited to sign/i)
    end
  end
end
