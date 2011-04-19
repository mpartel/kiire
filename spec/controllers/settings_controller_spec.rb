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

    it "should assign the current user agent" do
      request.env['HTTP_USER_AGENT'] = 'Testbrowser'
      get :show
      assigns[:user_agent].should == 'Testbrowser'
    end
  end

  describe "#update" do
    before do
      setting_keys = [:dont_require_login, :show_via_field, :mobile_browsers]

      @settings = setting_keys.map do |name|
        obj = mock_model(Setting)
        obj.stub!(:value=)
        obj.stub!(:save!)
        controller.stub_chain(:current_user, :get_setting).with(name.to_s).and_return(obj)
        { name => obj }
      end.reduce &:merge
    end

    describe "given new settings" do
      before do
        @params = {
          'settings' => {
            'dont_require_login' => '1',
            'show_via_field' => '0',
            'mobile_browsers' => "*Fennec*\n*iPod*"
          }
        }
      end

      it "should save dont_require_login" do
        @settings[:dont_require_login].should_receive(:value=).with('1')
        @settings[:dont_require_login].should_receive(:save!)
        put_update
      end

      it "should save show_via_field" do
        @settings[:show_via_field].should_receive(:value=).with('0')
        @settings[:show_via_field].should_receive(:save!)
        put_update
      end

      it "should save mobile_version" do
        @settings[:mobile_browsers].should_receive(:value=).with("*Fennec*\n*iPod*")
        @settings[:mobile_browsers].should_receive(:save!)
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
        @settings.each_value do |setting|
          setting.should_receive(:value=).with(nil)
          setting.should_receive(:save!)
        end
        put_update
      end
    end

    def put_update
      put :update, @params
    end
  end
end
