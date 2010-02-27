
require 'spec_helper'

describe ApplicationController do

  describe "#current_user" do
    describe "when there is a current user id in the session" do
      before do
        @user = mock_model(User)
        User.should_receive(:find_by_id).with(13).and_return(@user)
        session[:current_user_id] = 13
      end

      it "should return the user" do
        controller.send(:current_user).should == @user
      end
    end

    describe "when there is no current user id in the session" do
      it "should return nil" do
        controller.send(:current_user).should be_nil
      end
    end
  end

  describe "#check_authorization" do
    it "should require login by default" do
      controller.should_receive(:must_be_logged_in)
      controller.send(:check_authorization)
    end
  end

  describe "#must_be_logged_in" do
    describe "when there is no current user" do
      before do
        controller.stub!(:current_user).and_return(nil)
      end

      it "should redirect to the main page" do
        controller.should_receive(:redirect_to).with(new_session_path)
        controller.send(:must_be_logged_in)
      end
    end

    describe "when there is a current user" do
      before do
        @user = mock_model(User)
        controller.stub!(:current_user).and_return(@user)
      end

      it "should do nothing" do
        controller.send(:must_be_logged_in)
      end
    end
  end
end