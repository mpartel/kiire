class UsersController < ApplicationController
  def new
    @user = User.new
  end

  def create
    @user = User.new(params[:user])
    if @user.save
      flash[:success] = t("user.account_created")
      redirect_to new_session_path
    else
      render :action => :new
    end
  end

protected
  def check_authorization
  end
end
