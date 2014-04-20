class AlertMailer < ActionMailer::Base
  default from: "hello@signalcloudapp.com"

  def alert_email(search, listings)
    @user     = search.user
    @search   = search
    @listings = listings
    mail(to: to_with_name(@user.email, @user.name), subject: "#{ @listings.count } new listings for #{ @search.name }.")
  end
  
  def to_with_name(email, name=nil)
    if name.blank?
      email
    else
      "#{name} <#{email}>"
    end
  end

end
