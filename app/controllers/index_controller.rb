class IndexController < ApplicationController
  def index
    @places = addressed_user.places
  end

protected
  def check_authorization
    must_be_logged_in unless addressed_user && addressed_user.get_setting('dont_require_login').value
  end

end
