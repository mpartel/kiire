class SessionsController < ApplicationController
  def new
    @user = User.new
    @user.username = params[:username] || username_from_hostname
  end

  def create
    user = User.authenticate(params[:user][:username], params[:user][:password])
    if user
      session[:current_user_id] = user.id

      if username_from_hostname != user.username
        if request_at_default_port?
          redirect_to root_url(:host => hostname_without_username)
        else
          redirect_to root_url(:host => hostname_without_username, :port => request.port)
        end
      else
        redirect_to root_path
      end
    else
      flash[:error] = t("session.failed_to_log_in")
      redirect_to new_session_path
    end
  end

  def destroy
    reset_session
    
    redirect_to root_path
  end

protected
  def check_authorization
  end

private
  def request_at_default_port?
    (request.scheme == 'http' && request.port == 80) ||
      (request.scheme == 'https' && request.port == 443)
  end
end
