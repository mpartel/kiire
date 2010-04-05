class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.authenticate(params[:user][:username], params[:user][:password])
    if user
      session[:current_user_id] = user.id

      if username_from_hostname != user.username
        redirect_to root_url(:host => hostname_without_username)
      else
        redirect_to root_path
      end
    else
      flash[:error] = t("session.failed_to_log_in")
      redirect_to root_path
    end
  end

  def destroy
    reset_session
    
    redirect_to root_path
  end

protected
  def check_authorization
  end
end
