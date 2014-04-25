class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  ##
  # CanCan authorisation check
  check_authorization :unless => :devise_controller?

  ##
  # Protect with CanCan
  rescue_from CanCan::AccessDenied do |exception|
    session[:user_return_to] = request.fullpath
    redirect_to new_user_session_path, :alert => exception.message # unless Rails.environment.development?
  end

  ##
  # Add additional parameters for devise
  before_filter :configure_permitted_parameters, if: :devise_controller?

  def current_ability
    @current_ability ||= Ability.new(current_or_guest_user)
  end

  #
  # Provide either the current user (if signed in) or a guest user (if not)
  def current_or_guest_user
    if current_user
      if session[:guest_user_id]
        logging_in
        guest_user.destroy
        session[:guest_user_id] = nil
      end
      current_user
    else
      guest_user
    end
  end

  #
  # Find guest_user object associated with the current session,
  # creating one as needed
  def guest_user
    # Cache the value the first time it's gotten.
    @cached_guest_user ||= User.find(session[:guest_user_id] ||= create_guest_user.id)

  rescue ActiveRecord::RecordNotFound # if session[:guest_user_id] invalid
     session[:guest_user_id] = nil
     guest_user
  end
  
  def guest_user?
    current_or_guest_user.guest?
  end

  helper_method :current_or_guest_user, :guest_user?

  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :name
  end

  #
  # Called (once) when the user logs in, insert any code your application needs
  # to hand off from guest_user to current_user.
  def logging_in
    current_user.merge!(guest_user)
  end

  #
  # Create a new guest user
  def create_guest_user
    User.create(name: "Guest", email: "guest_#{Time.now.to_i}#{rand(99)}@mynextflat.co.uk", guest: true, real_email: false).tap do |u|
      u.save!(:validate => false)
      session[:guest_user_id] = u.id
    end
  end

end
