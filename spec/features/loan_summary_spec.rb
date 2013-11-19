require "spec_helper"

feature "User wanting to create a loan" do

  scenario "should be able to generate a loan summary", js: true do
    visit root_path
    fill_in "note_amount", with: "3000"
    fill_in "note_rate", with: "13.17"
    fill_in "note_term", with: "12"
    fill_in "note_start_date", with: "2013-12-01"
    page.should have_content "$268.19"
    page.should have_content "$3,218.28"
    page.should have_content "$218.28"
    page.should have_content "Dec. 2014"
  end
end
