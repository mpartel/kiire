require 'spec_helper'

describe PlacesController do
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

    it "should update backend-specific place settings if given" do
      @params['place']['settings'] = {
        'some_backend' => {
          'some_setting' => 'some_value'
        }
      }

      setting = mock_model(PlaceSetting)
      @place.should_receive('get_setting').with('some_setting', 'some_backend').and_return(setting)
      setting.should_receive(:value=).with('some_value')
      setting.should_receive(:save!)

      @place.should_receive(:update_attributes).with do |arg|
        arg['settings'].should be_nil
      end

      put_update
    end

    describe "when successful" do
      it "should redirect to the edit page" do
        put_update
        response.should redirect_to(edit_place_path(@place))
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

      it "should rerender the edit page with the place" do
        put_update
        assigns[:place].should === @place
        response.should render_template(:edit)
      end
    end

    def put_update
      put :update, @params
    end
  end
end
