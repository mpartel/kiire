class SettingsController < ApplicationController
  def show
    @places = current_user.places
    @new_place = Place.new
    @user_agent = request.env['HTTP_USER_AGENT']
  end

  def update
    user = current_user
    
    settings_to_save = ['dont_require_login', 'show_via_field', 'mobile_browsers']
    settings_to_save.each do |key|
      setting = user.get_setting(key)
      setting.value = if params[:settings] then params[:settings][key] else nil end
      setting.save!
    end

    flash[:success] = t('settings.saved')
    redirect_to settings_path
  end

end
