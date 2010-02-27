module ApplicationHelper
  def logged_in?
    !!current_user
  end

  def current_user
    controller.send(:current_user)
  end
end