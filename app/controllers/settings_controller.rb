class SettingsController < ApplicationController
  def index
    @places = current_user.places
    @new_place = Place.new
  end

end
