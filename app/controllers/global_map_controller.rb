class GlobalMapController < ApplicationController
  respond_to :json

  def show
    @user = current_user
  end

  def users
    @users = User.all.limit(100)

    render json: @users, each_serializer: UserSerializer,
           root: false
  end
end
