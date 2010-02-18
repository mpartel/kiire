require 'spec_helper'

describe IndexController do

  before do
    @user = mock_model(User)
  end

  describe "#index" do
    describe "when not logged in" do
      it "should redirect to the login page" do
        get :index
        response.should redirect_to(new_session_path)
      end
    end

    describe "when logged in" do
      before do
        stub_current_user(@user)
        
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
  end
end
