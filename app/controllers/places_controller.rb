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

  def destroy
    @place = current_user.places.find(params[:id])
    if @place.destroy
      flash[:success] = t("places.place_deleted")
    end
    redirect_to settings_path
  end

  def edit
    @place = current_user.places.find(params[:id])
  end

  def update
    @place = current_user.places.find(params[:id])

    if params[:place][:settings]
      params[:place][:settings].each do |backend, settings|
        settings.each do |key, value|
          setting = @place.get_setting(key, backend)
          setting.value = value
          setting.save!
        end
      end
      params[:place].delete(:settings)
    end

    @place.update_attributes(params[:place])
    if @place.save
      flash[:success] = t("places.place_updated")
      redirect_to settings_path
    else
      render :edit
    end
  end
end
