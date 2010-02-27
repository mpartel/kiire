require 'spec_helper'

describe UsersController do

  describe "#new" do
    it "should assign a new user" do
      user = mock_model(User)
      User.should_receive(:new).and_return(user)

      get :new
      
      assigns[:user].should == user
    end
  end

  describe "#create" do
    before do
      @params = { :user => mock(Hash) }
      @user = mock_model(User)
      User.stub!(:new).with(@params[:user]).and_return(@user)
    end

    it "should save the user" do
      @user.should_receive(:save)
      post_create
    end

    describe "when successful" do
      before do
        @user.stub!(:save => true)
      end

      it "should redirect to the home page" do
        post_create
        response.should redirect_to(root_path)
      end

      it "should display a success message" do
        post_create
        flash[:success].should_not be_nil
      end
    end

    describe "when failed" do
      before do
        @user.stub!(:save => false)
      end

      it "should rerender the registration form" do
        post_create
        assigns[:user].should == @user
        response.should render_template(:new)
      end
    end

    def post_create
      post :create, @params
    end
  end

  describe "#check_authorization" do
    it "should require login" do
      controller.should_not_receive(:must_be_logged_in)
      controller.send(:check_authorization)
    end
  end
end
