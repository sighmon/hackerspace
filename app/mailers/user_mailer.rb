class UserMailer < ActionMailer::Base
  # default email
  default :from => ENV["DEVISE_EMAIL_ADDRESS"]

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.user_mailer.subscription_confirmation.subject
  #
  default :bcc => ENV["DEVISE_BCC_EMAIL_ADDRESSES"]
  if Rails.env.development?
    default :bcc => ENV["DEVISE_BCC_EMAIL_ADDRESSES_DEV"]
  end

  def user_signup_confirmation(user)
    @user = user
    @greeting = "Hello"
    mail(:to => user.email, :subject => "Hackerspace Adelaide - Welcome!")
  end

  def membership_confirmation(user)
    @user = user
    @greeting = "Hi"
    mail(:to => user.email, :subject => "Hackerspace Adelaide membership")
  end

  def membership_cancellation(user)
    @user = user
    @greeting = "Hi"
    mail(:to => user.email, :subject => "Cancelled Hackerspace Adelaide membership cancelled")
  end

  def membership_cancelled_via_paypal(user)
    @user = user
    @greeting = "Hi"
    mail(:to => user.email, :subject => "Cancelled Hackerspace Adelaide membership cancelled via PayPal")
  end

  def membership_recurring_payment_outstanding_payment(user)
    @user = user
    @greeting = "Hi"
    mail(:to => ENV["DEVISE_EMAIL_ADDRESS"], :subject => "recurring_payment_outstanding_payment - Hackerspace Adelaide membership")
  end

end
