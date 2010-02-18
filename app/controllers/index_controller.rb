class IndexController < ApplicationController
  def index
    if logged_in?
      @places = current_user.places
    else
      redirect_to new_session_path
    end
  end

end
