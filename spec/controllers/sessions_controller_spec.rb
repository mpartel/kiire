require 'spec_helper'

describe SessionsController do
  describe "#new" do
    before do
      @user = mock_model(User)
      @user.stub!(:username=).with(nil)
      User.stub!(:new).and_return(@user)
    end

    it "should render the template with an empty user" do
      get :new
      assigns[:user].should == @user
      response.should render_template(:new)
    end

    it "should prefill the username if the hostname has one" do
      controller.stub!(:username_from_hostname).and_return('kaylee')
      @user.should_receive(:username=).with('kaylee')
      get :new
    end

    it "should prefill the username if there is one in the parameter" do
      @user.should_receive(:username=).with('kaylee')
      get :new, :username => 'kaylee'
    end

    it "should prefer the username in the parameter" do
      controller.stub!(:username_from_hostname).and_return('jayne')
      @user.should_receive(:username=).with('kaylee')
      get :new, :username => 'kaylee'
    end
  end

  describe "#create" do
    before do
      @params = {
        :user => {
          :username => 'jayne',
          :password => 'vera'
        }
      }
    end

    def post_create
      post :create, @params
    end

    describe "with no existing credentials" do
      describe "given correct credentials" do
        before do
          @user = mock_model(User, :username => 'jayne')
          User.should_receive(:authenticate).with('jayne', 'vera').and_return(@user)
        end

        it "should create a session" do
          post_create
          session[:current_user_id].should == @user.id
        end

        it "should redirect to index" do
          post_create
          response.should redirect_to(root_path)
        end

        describe "with username different from the one in the hostname" do
          it "should redirect so that the hostname has no username" do
            controller.stub!(:username_from_hostname).and_return('kaylee')
            controller.stub!(:hostname_without_username).and_return('kiire.fi')
            post_create
            response.should redirect_to(root_url :host => 'kiire.fi')
          end
        end
      end

      describe "given incorrect credentials" do
        before do
          User.should_receive(:authenticate).and_return(false)
        end

        it "should not create a session" do
          post_create
          session[:current_user_id].should be_nil
        end

        it "should display an error" do
          post_create
          flash[:error].should_not be_nil
        end

        it "should redirect to the login page" do
          post_create
          response.should redirect_to(new_session_path)
        end
      end
    end
  end

  describe "#destroy" do
    def post_destroy
      post :destroy
    end

    it "should destroy the session" do
      controller.should_receive(:reset_session)
      post_destroy
    end

    it "should redirect to index" do
      post_destroy
      response.should redirect_to(root_path)
    end
  end

  describe "#check_authorization" do
    it "should not require login" do
      controller.should_not_receive(:must_be_logged_in)
      controller.send(:check_authorization)
    end
  end
end
