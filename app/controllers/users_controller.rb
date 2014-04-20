class UsersController < ProtectedController
  respond_to :html

  def update
    authorize! :update, current_or_guest_user

    attributes = self.user_params
    attributes.delete(:email) if attributes[:email].blank?
    attributes[:real_email] = attributes[:email].present?

    flash[:notice] = 'Your profile was updated.' if current_or_guest_user.update_attributes(attributes)
    redirect_to edit_user_registration_path
  end
  
  protected
  
  def user_params
    params.require(:user).permit(:name, :email)
  end

end
