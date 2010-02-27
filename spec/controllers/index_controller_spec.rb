require 'spec_helper'

describe IndexController do

  before do
    @user = mock_model(User)
    stub_current_user(nil)
    stub_addressed_user(@user)
  end

  describe "#index" do
    before do
      controller.stub!(:check_authorization)
      @places = mock(Array)
      @user.stub!(:places => @places)
    end

    it "should render the template" do
      get :index
      response.should render_template(:index)
    end

    it "should assign the user's places" do
      get :index
      assigns[:places].should == @places
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
      end

      describe "when the user has set the dont_require_login_option" do
        before do
          @user.stub!(:get_setting).with('dont_require_login').and_return(mock_model(Setting, :value => 1))
        end

        it "should not require login" do
          controller.should_not_receive(:must_be_logged_in)
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
end
