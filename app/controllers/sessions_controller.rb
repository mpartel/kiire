class SessionsController < ApplicationController
  def create
    user = User.authenticate(params[:user][:username], params[:user][:password])
    if user
      session[:current_user_id] = user.id
    else
      flash[:error] = t("session.failed_to_log_in")
    end

    redirect_to root_path
  end

  def destroy
    reset_session
    
    redirect_to root_path
  end

end
