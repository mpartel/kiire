require 'spec_helper'

describe SessionsController do
  describe "#new" do
    it "should render the template" do
      get :new
      response.should render_template(:new)
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
          @user = mock_model(User)
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

        it "should redirect to index" do
          post_create
          response.should redirect_to(root_path)
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
end
