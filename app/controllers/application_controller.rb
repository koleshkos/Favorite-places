class ApplicationController < ActionController::Base
  before_action :authenticate_user!

  def after_sign_in_path_for(resource)
    stored_location_for(resource) ||
      if resource.is_a?(User)
        user_path(current_user)
      else
        super
      end
  end

  # rubocop:disable Style/UnusedMethodArgument
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path
  end
  # rubocop:enable Style/UnusedMethodArgument
end
