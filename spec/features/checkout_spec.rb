require "spec_helper"

feature "User wanting to lend money" do
  # Given I am a logged in user on /
  # when I click the button "Create a loan"
  # then I am sent to /notes/new
  #
  # Given I'm on /notes/new
  # when I have filled out all the information
  # and click the button "Checkout with dwolla"
  # then a note is created
  # and I should see /notes/:id

  given!(:user) {create(:user)}

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
  end

  scenario "creates a promissory note on lending round" do
    visit signin_path
    click_on "Generate a loan!"
    page.current_path.should == new_note_path
    fill_in "note_amount",     with: 6000
    fill_in "note_rate",       with: 11.0
    fill_in "note_term",       with: 36
    fill_in "note_start_date", with: "2013/10/27"

    [
      {type: "lender", first: "Bob", last: "Raymond", email: "bobraymond@gmail.com", address: "270 Boylston St Boston MA 02116" },
      {type: "borrower", first: "Terry", last: "Nichols", email: "terrynichols@gmail.com", address: "1358 Richard Dr Boston MA 02115" }
    ].each do |lender_or_borrower|
      type = lender_or_borrower[:type]
      first = lender_or_borrower[:first]
      last = lender_or_borrower[:last]
      email = lender_or_borrower[:email]
      address = lender_or_borrower[:address]
      fill_in "note_#{type}_name",       with: [last, first].join(" ")
      fill_in "note_#{type}_email",      with: email
      fill_in "note_#{type}_address",    with: address
    end

    click_button "Create the Promissory Note!"
    page.current_path.should match /\/notes\//
    user.notes.count.should == 1
    page.should have_content /review promissory note/i
    page.should have_content "The loan amount is for $6000"
    page.should have_content "The Interest Rate is for 11.0%"
    page.should have_content "It lasts for 36 months"
    page.should have_content "First Payment Date is October 27, 2013"
  end
end
