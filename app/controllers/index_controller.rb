class IndexController < ApplicationController

  def index
    @places = addressed_user.places
  end

protected
  def check_authorization
    apply_hostname
    must_be_logged_in unless addressed_user && addressed_user.get_setting('dont_require_login').value
  end

  def addressed_user
    if current_user
      current_user
    elsif params[:username]
      User.find_by_username(params[:username])
    end
  end

  def apply_hostname
    username = username_from_hostname
    params[:username] = username if username
  end

end
