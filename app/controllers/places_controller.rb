class PlacesController < ApplicationController
  def create
    place = current_user.places.new(params[:place])
    if place.save
      flash[:success] = t("places.new_place_added")
    else
      flash[:error] = t("places.failed_to_add_new_place")
    end

    redirect_to settings_path
  end
end