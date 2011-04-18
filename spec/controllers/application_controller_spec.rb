
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

  describe "#username_from_hostname" do
    it "should return nil if the hostname has less than three parts" do
      request.host = 'somehost'
      controller.send(:username_from_hostname).should be_nil
      request.host = 'example.com'
      controller.send(:username_from_hostname).should be_nil
    end

    it "should return the first part if the hostname has at least three parts" do
      request.host = 'foo.example.com'
      controller.send(:username_from_hostname).should == 'foo'
      request.host = 'boo.hoo.example.com'
      controller.send(:username_from_hostname).should == 'boo'
    end

    it "should return nil if the first part of the hostname is reserved" do
      request.host = 'www.example.com'
      controller.send(:username_from_hostname).should be_nil
      request.host = 'www.hoo.example.com'
      controller.send(:username_from_hostname).should be_nil
    end

    it "should return nil if the hostname is an IPv4 address" do
      request.host = '127.0.0.1'
      controller.send(:username_from_hostname).should be_nil
      request.host = '241.8.32.11'
      controller.send(:username_from_hostname).should be_nil
    end
  end

  describe "hostname_without_username" do
    describe "when the hostname has less than three parts" do
      it "should return the current hostname" do
        request.host = 'example.com'
        controller.send(:hostname_without_username).should == 'example.com'
      end
    end

    describe "when the hostname has at least three parts" do
      it "should return the hostname without the first parts" do
        request.host = 'foo.example.com'
        controller.send(:hostname_without_username).should == 'example.com'
        request.host = 'foo.zoo.example.com'
        controller.send(:hostname_without_username).should == 'example.com'
      end

      it "should return the hostname with the first part if it is reserved" do
        request.host = 'www.example.com'
        controller.send(:hostname_without_username).should == 'www.example.com'
        request.host = 'www.funny.example.com'
        controller.send(:hostname_without_username).should == 'www.funny.example.com'
      end

      it "should return an IPv4 address unchanged" do
        request.host = '127.0.0.1'
        controller.send(:hostname_without_username).should == '127.0.0.1'
        request.host = '42.123.1.44'
        controller.send(:hostname_without_username).should == '42.123.1.44'
      end
    end
  end
end