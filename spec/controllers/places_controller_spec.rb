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
        'id' => '3'
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

  describe "#show" do
    it "should assign the place" do
      place = mock_model(Place)
      controller.stub_chain(:current_user, :places, :find).with(place.id.to_s).and_return(place)

      get :show, :id => place.id.to_s

      assigns[:place].should == place
    end
  end

  describe "#update" do
    before do
      @place = mock_model(Place)
      controller.stub_chain(:current_user, :places, :find).with(@place.id.to_s).and_return(@place)

      @params = {
        'id' => @place.id.to_s,
        'place' => {
          'name' => 'New Name'
        }
      }

      @place.stub!(:update_attributes)
      @place.stub!(:save).and_return(true)
    end

    it "should update the attributes of the place" do
      @place.should_receive(:update_attributes).with(@params['place'])
      put_update
    end

    describe "when successful" do
      it "should redirect to the show page" do
        put_update
        response.should redirect_to(place_path(@place))
      end

      it "should show a success message" do
        put_update
        flash[:success].should_not be_nil
      end
    end

    describe "when unsuccessful" do
      before do
        @place.should_receive(:save).and_return(false)
      end

      it "should rerender the show page with the place" do
        put_update
        assigns[:place].should === @place
        response.should render_template(:new)
      end
    end

    def put_update
      put :update, @params
    end
  end
end
