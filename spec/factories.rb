FactoryGirl.define do
  factory :user do
    provider "dwolla"
    uid "100004721472441"
    sequence(:name) { |n| "user#{n}"}
    email { |user| "#{user.name}@example.com".downcase}
  end
end
