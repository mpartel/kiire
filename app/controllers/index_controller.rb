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
    reserved_prefixes = ['www', 'ftp', 'img']

    parts = request.host.split('.')
    if parts.length > 2
      username = parts[0]
      params[:username] = username unless reserved_prefixes.include? username
    end
  end

end
