class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :a, as: :amount, type: Integer
  field :r, as: :rate, type: BigDecimal
  field :t, as: :term, type: Integer
  field :sd, as: :start_date, type: Date

  has_one :lender, class_name: "User"
  has_one :borrower, class_name: "User"

  %w(lender borrower).each do |lender_or_borrower|
    accepts_nested_attributes_for :"#{lender_or_borrower}", reject_if: proc { |obj| obj.blank? }
  end
end
