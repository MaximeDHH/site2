class ApplicationMailer < ActionMailer::Base
  default from: ENV.fetch('MAIL_FROM', 'Royal Nail <contact@royalnail.fr>')

  # En dev, tous les mails vont vers l'adresse de test
  if Rails.env.development?
    default to: ENV.fetch('DEV_MAIL_RECIPIENT', 'maxime.beauge@gmail.com')
  end
  layout "mailer"
end
