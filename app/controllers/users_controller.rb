class UsersController < ApplicationController
  def index
    if user_signed_in?
      redirect_to user_path(current_user)
    else
      redirect_to new_user_session_path
    end
  end

  def show
    @user = User.find(params[:id])
  end
end
