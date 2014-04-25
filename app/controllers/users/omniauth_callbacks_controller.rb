class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController
  include Devise::Controllers::Rememberable

  def twitter
    @user = User.find_or_create_with_twitter_oauth(request.env["omniauth.auth"])

    # If the user is persisted, they've registered before so sign on in!
    if @user.persisted?
      remember_me(@user)
      set_flash_message(:notice, :success, :kind => "Twitter") if is_navigational_format?
      sign_in_and_redirect @user, :event => :authentication #this will throw if @user is not activated

    # Otherwise register
    else
      session["devise.twitter_data"] = request.env["omniauth.auth"].except("extra")
      logger.info(session["devise.twitter_data"])
      redirect_to new_user_registration_url

    end
  end

end
