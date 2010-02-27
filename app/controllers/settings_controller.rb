class SettingsController < ApplicationController
  def show
    @places = current_user.places
    @new_place = Place.new
  end

  def update
    user = current_user
    params[:settings].each do |key, value|
      setting = user.get_setting(key)
      setting.value = value
      setting.save!
    end
    redirect_to settings_path
  end

end
