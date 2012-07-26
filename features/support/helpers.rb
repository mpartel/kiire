class Cucumber::Rails::World
  def current_user
    @current_user ||= FactoryGirl.create(:user)
  end
  attr_writer :current_user
end