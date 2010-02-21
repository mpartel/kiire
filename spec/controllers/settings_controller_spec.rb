require 'spec_helper'

describe SettingsController do

  describe "#index" do
    before do
      @places = mock(Array)
      controller.stub_chain(:current_user, :places).and_return(@places)

      @new_place = mock_model(Place)
      Place.should_receive(:new).and_return(@new_place)
    end

    it "should assign places" do
      get :index
      assigns[:places].should == @places
    end

    it "should assign an empty new place" do
      get :index
      assigns[:new_place].should == @new_place
    end
  end

  describe "#update" do
    
  end
end
