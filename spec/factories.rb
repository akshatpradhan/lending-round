FactoryGirl.define do
  factory :user do
    provider "dwolla"
    uid "100004721472441"
    sequence(:name) { |n| "user#{n}"}
    email { |user| "#{user.name}@example.com".downcase}
  end

  factory :note do
    amount 6000
    rate   11.0
    term 36
    start_date Time.now.to_date
    lender_name "Bob Raymond"
    lender_email "bobraymond@gmail.com"
    lender_address "270 Boylston St Boston MA 02116"
    borrower_name "Terry Nichols"
    borrower_email "terrynichols@gmail.com"
    borrower_address "1358 Richard Dr Boston MA 02115"
  end
end
