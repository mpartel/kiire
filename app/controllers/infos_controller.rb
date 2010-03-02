class InfosController < ApplicationController
  def show
    render :template => "infos/show.#{I18n.locale}.html"
  end

protected
  def check_authorization
  end
end
