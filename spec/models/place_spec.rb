require 'spec_helper'

describe Place do

  before do
    @place = FactoryGirl.build(:place)
  end

  it "should belong to a user" do
    @place.should respond_to(:user)
    @place.user.should be_a(User)
  end

  it "should have place settings" do
    @place.settings.should be_a(Enumerable)
    @place.settings.new.should be_a(PlaceSetting)
  end

  it "should be the last in the place list when created" do
    p1 = FactoryGirl.create(:place)
    p2 = FactoryGirl.create(:place)
    @place = p2.user.places.new(:name => 'new_place')
    @place.save!
    @place.user.should == p2.user
    @place.ordinal.should > p1.ordinal
    @place.ordinal.should > p2.ordinal
  end

  it "should save place settings when saved" do
    ps = FactoryGirl.build(:place_setting, :place => @place)
    @place.settings << ps
    ps.should be_new_record
    @place.save
    ps.should_not be_new_record
  end

  describe "validation" do
    it "should be valid when constructed by the factory" do
      @place.should be_valid
    end

    it "should require a name" do
      @place.name = nil
      @place.should have(1).error_on(:name)
    end

    it "should require an unambiguous ordering" do
      @place.save!
      place2 = FactoryGirl.build(:place, :user => @place.user)
      place2.ordinal = @place.ordinal
      place2.should have(1).error_on(:ordinal)
    end
  end

  describe "#client_attributes" do
    it "should return a hash with string keys" do
      @place.client_attributes.should be_a(Hash)
      @place.client_attributes.should == @place.client_attributes.stringify_keys
    end

    it "should include exactly the id, name and settings" do
      setting_attribs = mock(Hash)
      @place.should_receive(:settings_as_client_attributes).and_return(setting_attribs)

      result = @place.client_attributes

      result.should == {
        'id' => @place.id,
        'name' => @place.name,
        'settings' => setting_attribs
      }
    end
  end

  describe "#settings_as_client_attributes" do
    it "should return each setting as a key value pair, categorized under a backend" do
      setting1 = mock_model(PlaceSetting, :backend => nil, :key => 's1', :value => 'v1')
      setting2 = mock_model(PlaceSetting, :backend => 'b2', :key => 's2', :value => 'v2')
      setting3 = mock_model(PlaceSetting, :backend => 'b2', :key => 's3', :value => 'v3')
      setting4 = mock_model(PlaceSetting, :backend => 'b3', :key => 's4', :value => nil)

      settings = [
        setting1,
        setting2,
        setting3,
        setting4
      ]
      @place.stub!(:settings => settings)

      result = @place.send(:settings_as_client_attributes)

      result.should == {
        's1' => 'v1',
        'b2' => {
          's2' => 'v2',
          's3' => 'v3'
        },
        'b3' => {
          's4' => nil
        }
      }
    end
  end
end
