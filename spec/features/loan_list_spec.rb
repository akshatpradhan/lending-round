require "spec_helper"

feature "Registered user with loans" do
  #Given I’m on notes/:id
  #When i click “Go to My Profile” (current_user_path?)
  #Then I should be redirected to users/:id and 
  #then I should see a link to notes/:id

  #Given I'm on users/:id
  #When I click a Loan
  #Then I should be redirected to notes/:id
  #
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

  scenario "can see his loans on his profile page" do
    visit note_path(note)
    click_on "Go to My Profile"
    page.current_path.should == user_path(user)
    click_on "Loan #{note.id}"
    page.current_path.should == note_path(note)
  end
end
