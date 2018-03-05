class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  protected
    # https://github.com/plataformatec/devise/wiki/How-To%3A-Redirect-to-a-specific-page-on-successful-sign-in-and-sign-out
    def after_sign_in_path_for(resource)
      user_path(current_user)
    end
end
