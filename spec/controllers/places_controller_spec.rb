require 'spec_helper'

describe PlacesController do
  describe "#create" do
    before do
      @params = { :place => mock(Hash) }

      @place = mock_model(Place)
      controller.stub_chain(:current_user, :places, :new).with(@params[:place]).and_return(@place)
    end

    describe "when saving the new place succeeds" do
      before do
        @place.should_receive(:save).and_return(true)
      end

      it "should show a success message" do
        post_create
        flash[:success].should_not be_nil
      end

      it "should redirect to the settings page" do
        post_create
        response.should redirect_to(settings_path)
      end
    end

    describe "when saving the new place fails" do
      before do
        @place.should_receive(:save).and_return(false)
      end

      it "should show an error message" do
        post_create
        flash[:error].should_not be_nil
      end

      it "should redirect to the settings page" do
        post_create
        response.should redirect_to(settings_path)
      end
    end

    def post_create
      post :create, @params
    end
  end

  describe "#destroy" do
    before do
      @params = {
        :id => '3'
      }

      @place = mock_model(Place)
      @place.stub!(:destroy).and_return(true)

      controller.stub_chain(:current_user, :places, :find).with('3').and_return(@place)
    end

    it "should destroy the given place" do
      @place.should_receive(:destroy).and_return(true)
      delete_destroy
    end

    it "should redirect to the settings page" do
      delete_destroy
      response.should redirect_to(settings_path)
    end

    describe "when successful" do
      it "should show a success message" do
        delete_destroy
        flash[:success].should_not be_nil
      end
    end

    def delete_destroy
      delete :destroy, @params
    end
  end
end
