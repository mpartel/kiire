class InfosController < ApplicationController
  def show
    render :template => "infos/show.#{I18n.locale}", :format => :html
  end

protected
  def check_authorization
  end
end
