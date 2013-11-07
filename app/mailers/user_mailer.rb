class UserMailer < ActionMailer::Base
  default from: "from@example.com"

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.loan_invite.subject
  #
  def loan_invite(note)
    @note = note

    mail to: @note.borrower_email
  end
end
