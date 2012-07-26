require 'spec_helper'

describe PositionsController do
  describe "#update" do
    before do
      @user = FactoryGirl.create(:user)
      stub_current_user(@user)
      @places = (1..3).map {|n| FactoryGirl.create(:place, :id => n, :user => @user) }
    end
    
    describe "given a valid move-below request" do
      it "should move the given place to be immediately after the given place" do
        @user.should_receive(:move_place_after).with(@places[2], @places[0])
        put :update, :place_id => @places[2].id, :below => @places[0].id
        check_response
      end

      describe "with :below => 'top'" do
        it "should move the given place to the top" do
          @user.should_receive(:move_place_after).with(@places[2], nil)
          put :update, :place_id => @places[2].id, :below => 'top'
          check_response
        end
      end

      def check_response
        response.should be_successful
        response.content_type.should == 'text/plain'
        response.body.should == 'OK'
      end
    end

    describe "given an invalid move-below request" do
      it "should return a failure status code and the text 'FAIL'" do
        @user.stub(:move_place_after).and_throw(Exception.new)
        put :update, :place_id => 123, :below => 'top'
        response.should_not be_successful
        response.status.should == 500
        response.content_type.should == 'text/plain'
        response.body.should == 'FAIL'
      end
    end
  end
end
