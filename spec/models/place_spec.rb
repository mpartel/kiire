require 'spec_helper'

describe Place do

  before do
    @place = Factory.build(:place)
  end

  it "should belong to a user" do
    @place.should respond_to(:user)
    @place.user.should be_a(User)
  end

  it "should have place settings" do
    @place.settings.should be_a(Enumerable)
    @place.settings.new.should be_a(PlaceSetting)
  end

  describe "validation" do
    it "should be valid when constructed by the factory" do
      @place.should be_valid
    end

    it "should require a name" do
      @place.name = nil
      @place.should have(1).error_on(:name)
    end

    it "should not require a (serialized) style" do
      @place.serialized_style = nil
      @place.should be_valid
    end
  end
end
