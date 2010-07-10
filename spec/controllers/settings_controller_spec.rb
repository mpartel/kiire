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
      @dont_require_login = mock_model(Setting)
      @show_via_field = mock_model(Setting)
      controller.stub_chain(:current_user, :get_setting).with('dont_require_login').and_return(@dont_require_login)
      controller.stub_chain(:current_user, :get_setting).with('show_via_field').and_return(@show_via_field)
    end

    describe "given new settings" do
      before do
        @params = {
          'settings' => {
            'dont_require_login' => '1',
            'show_via_field' => '0'
          }
        }

        @dont_require_login.should_receive(:value=).with('1')
        @dont_require_login.stub!(:save!)

        @show_via_field.should_receive(:value=).with('0')
        @show_via_field.stub!(:save!)
      end

      it "should save dont_require_login" do
        @dont_require_login.should_receive(:save!)
        put_update
      end

      it "should save show_via_field" do
        @show_via_field.should_receive(:save!)
        put_update
      end

      it "should set a success message" do
        put_update
        flash[:success].should_not be_empty
      end

      it "should redirect to the show settings page" do
        put_update
        response.should redirect_to(settings_path)
      end
    end

    describe "given no parameters" do # (all parameters nil)
      it "should unset all parameters" do
        @dont_require_login.should_receive(:value=).with(nil)
        @dont_require_login.should_receive(:save!)
        @show_via_field.should_receive(:value=).with(nil)
        @show_via_field.should_receive(:save!)
        put_update
      end
    end

    def put_update
      put :update, @params
    end
  end
end
