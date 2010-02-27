require 'spec_helper'

describe SettingsController do

  describe "#show" do
    before do
      @places = mock(Array)
      controller.stub_chain(:current_user, :places).and_return(@places)

      @new_place = mock_model(Place)
      Place.should_receive(:new).and_return(@new_place)
    end

    it "should assign places" do
      get :show
      assigns[:places].should == @places
    end

    it "should assign an empty new place" do
      get :show
      assigns[:new_place].should == @new_place
    end
  end

  describe "#update" do
    before do
      @params = {
        'settings' => {
          'some_option' => 'some_setting'
        }
      }

      @setting = mock_model(Setting)
      controller.stub_chain(:current_user, :get_setting).with('some_option').and_return(@setting)

      @setting.should_receive(:value=).with('some_setting')
      @setting.stub!(:save!)
    end

    it "should save settings" do
      @setting.should_receive(:save!)
      put_update
    end

    it "should redirect to the show settings page" do
      put_update
      response.should redirect_to(settings_path)
    end

    def put_update
      put :update, @params
    end
  end
end
