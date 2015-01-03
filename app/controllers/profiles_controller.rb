class ProfilesController < ProtectedController
  respond_to :html

  def update
    authorize! :update, current_or_guest_user

    attributes = self.user_params
    attributes.delete(:email) if attributes[:email].blank?

    flash[:notice] = 'Your profile was updated.' if current_or_guest_user.update_attributes(attributes)
    redirect_to edit_user_path(current_or_guest_user)
  end
  
  protected
  
  def user_params
    params.require(:user).permit(:name, :email)
  end

end
