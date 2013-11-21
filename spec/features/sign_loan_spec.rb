require "spec_helper"

feature "User wanting to sign a loan" do

#Given I'm on notes/new,
#when I create a loan
#then I'm redirected to notes/:id

#Given I'm on notes/:id
#when i click 'Sign a loan'
#then I'm redirected to notes/:id/edit

#Given I'm on notes/:id/edit
#When I enter my name and click 'Agree'
#Then I'm redirected to notes/:id

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
    visit signin_path
  end

  scenario "successfully sign a loan" do
    visit new_note_path
    fill_in "note_amount",     with: 6000
    fill_in "note_rate",       with: 11.0
    fill_in "note_term",       with: 36
    fill_in "note_start_date", with: "2013/10/27"

    [
      {type: "lender", name: user.name, email: "bobraymond@gmail.com", address: "270 Boylston St Boston MA 02116" },
      {type: "borrower", name: "Terry Nichols", email: "terrynichols@gmail.com", address: "1358 Richard Dr Boston MA 02115" }
    ].each do |lender_or_borrower|
      type = lender_or_borrower[:type]
      name = lender_or_borrower[:name]
      email = lender_or_borrower[:email]
      address = lender_or_borrower[:address]
      fill_in "note_#{type}_name",       with: name
      fill_in "note_#{type}_email",      with: email
      fill_in "note_#{type}_address",    with: address
    end
    click_button "Show me the Promissory Note!"
    fill_in "note_signed_by_lender", with: user.name
    click_button "lender_sign"
    page.should have_content "#{user.name} has signed the promissory note"
    page.should_not have_button "lender_sign"
    fill_in "note_signed_by_borrower", with: "Terry Nichols"
    click_button "borrower_sign"
    page.should have_content "Terry Nichols has signed the promissory note"
    page.should_not have_button "borrower_sign"
  end
end
