require 'spec_helper'

describe InfosController do
  it "should not require login" do
    controller.should_not_receive(:must_be_logged_in)
    controller.send(:check_authorization)
  end

  describe "#show" do
    it "should render the template according to the current locale" do
      I18n.locale= :et
      get :show
      response.should render_template('infos/show.et.html')
    end
  end
end