# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  protect_from_forgery # See ActionController::RequestForgeryProtection for details

  # Scrub sensitive parameters from your log
  filter_parameter_logging :password, :password_confirm

  before_filter :check_authorization

protected

  def check_authorization
    must_be_logged_in
  end

  def must_be_logged_in
    unless current_user
      redirect_to new_session_path
    end
  end

  def current_user
    User.find_by_id(session[:current_user_id])
  end

  def logged_in?
    !!current_user
  end

  def username_from_hostname
    parts = request.host.split('.')
    if parts.length > 2
      username = parts.first
      return username unless reserved_hostname_prefixes.include? username
    end

    return nil
  end

  def hostname_without_username
    parts = request.host.split('.')
    if parts.length > 2 and !reserved_hostname_prefixes.include?(parts.first)
      parts.reverse.take(2).reverse.join '.'
    else
      request.host
    end
  end

  def reserved_hostname_prefixes
    ['www', 'ftp', 'img']
  end
end
