require 'spec_helper'

describe IndexController do

  before do
    @user = mock_model(User)
    stub_current_user(@user)
  end

  describe "#index" do
    before do
      controller.stub!(:check_authorization)
      @places = mock(Array)
      @user.stub!(:places => @places)
      @user.stub!(:get_setting_value).with(:show_via_field).and_return('1')
      @user.stub!(:get_setting_value).with(:mobile_reittiopas).and_return('always')
    end

    it "should render the template" do
      get :index
      response.should render_template(:index)
    end

    it "should assign the user's places" do
      get :index
      assigns[:places].should == @places
    end

    it "should tell the view whether to show the via field" do
      get :index
      assigns[:show_via_field].should == '1'
    end

    it "should pass the mobile Reittiopas setting to the view" do
      get :index
      assigns[:mobile_reittiopas].should == 'always'
    end

  end

  describe "#check_authorization" do
    describe "when there is an addressed user" do
      before do
        stub_addressed_user(@user)
      end

      describe "when the user has not set the dont_require_login option" do
        before do
          @user.stub!(:get_setting).with('dont_require_login').and_return(mock_model(Setting, :value => nil))
        end

        it "should require login" do
          controller.should_receive(:must_be_logged_in)
          controller.send(:check_authorization)
        end

        it "should apply the hostname" do
          controller.should_receive(:apply_hostname)
          controller.send(:check_authorization)
        end
      end

      describe "when the user has set the dont_require_login_option" do
        before do
          @user.stub!(:get_setting).with('dont_require_login').and_return(mock_model(Setting, :value => 1))
        end

        it "should not require login" do
          controller.should_not_receive(:must_be_logged_in)
          controller.send(:check_authorization)
        end

        it "should apply the hostname" do
          controller.should_receive(:apply_hostname)
          controller.send(:check_authorization)
        end
      end
    end

    describe "when there is no addressed user" do
      before do
        stub_addressed_user(nil)
      end

      it "should require login" do
        controller.should_receive(:must_be_logged_in)
        controller.send(:check_authorization)
      end
    end
  end

  describe "#addressed_user" do
    describe "when there is a current user" do
      before do
        stub_current_user(@user)
      end

      it "should return the current user" do
        controller.send(:addressed_user).should == @user
      end
    end

    describe "when there is no current user" do
      before do
        controller.stub!(:current_user).and_return(nil)
      end

      describe "when there is a username parameter" do
        before do
          controller.params[:username] = 'foo'
        end

        it "should return the user by that username (case-insensitive)" do
          @user = mock_model(User)
          User.should_receive(:find_by_username_case_insensitive).with('foo').and_return(@user)

          controller.send(:addressed_user).should == @user
        end
      end
    end
  end

  describe "#apply_hostname" do
    describe "given no subdomain" do
      before do
        request.stub!(:host => 'kiire.fi')
      end

      it "should not set the username parameter" do
        controller.send(:apply_hostname)
        controller.params[:username].should == nil
      end
    end

    describe "given a reserved subdomain like 'www'" do
      before do
        request.stub!(:host => 'www.kiire.fi')
      end

      it "should not set the username parameter" do
        controller.send(:apply_hostname)
        controller.params[:username].should == nil
      end
    end

    describe "given a non-reserved subdomain" do
      before do
        request.stub!(:host => 'jussi.kiire.fi')
      end

      it "should set the username parameter" do
        controller.send(:apply_hostname)
        controller.params[:username].should == 'jussi'
      end
    end
  end
end
