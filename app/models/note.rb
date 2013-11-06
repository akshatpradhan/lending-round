class Note
  include Mongoid::Document
  include Mongoid::Timestamps

  field :a, as: :amount, type: Integer
  field :r, as: :rate, type: BigDecimal
  field :t, as: :term, type: Integer
  field :sd, as: :start_date, type: Date
  field :ln, as: :lender_name
  field :ln, as: :lender_email
  field :la, as: :lender_address
  field :bn, as: :borrower_name
  field :ln, as: :borrower_email
  field :ba, as: :borrower_address

  attr_accessible :amount, :rate, :term, :start_date, :lender_name, :lender_email, :lender_address, :borrower_name, :borrower_email, :borrower_address
end
