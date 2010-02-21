module ApplicationHelper
  def logged_in?
    !!controller.send(:current_user)
  end
end