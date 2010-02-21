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
end
