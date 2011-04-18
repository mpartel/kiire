class IndexController < ApplicationController

  def index
    @places = addressed_user.places
    @show_via_field = addressed_user.get_setting_value(:show_via_field)
    @mobile_reittiopas = addressed_user.get_setting_value(:mobile_reittiopas)
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
      User.find_by_username_case_insensitive(params[:username])
    end
  end

  def apply_hostname
    username = username_from_hostname
    params[:username] = username if username
  end

end
