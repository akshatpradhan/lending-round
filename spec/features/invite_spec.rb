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
  given!(:note) {create(:note)}

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
    visit signin_path
  end

  scenario "invites the borrower through an automatic email" do
    visit new_note_path
    fill_in "note_amount",     with: 6000
    fill_in "note_rate",       with: 11.0
    fill_in "note_term",       with: 36
    fill_in "note_start_date", with: "2013/10/27"

    borrower_email = "terrynichols@gmail.com"
    fill_in "note_lender_email",   with: user.email
    fill_in "note_borrower_email", with: borrower_email
    click_button "Checkout with Dwolla!"
    mail = ActionMailer::Base.deliveries.last
    mail.to.should include borrower_email
    mail.body.encoded.should match(/#{note_path(Note.last)}/)
  end

  scenario "borrower accepts invitation to see the loan" do
    pending
  end

end
