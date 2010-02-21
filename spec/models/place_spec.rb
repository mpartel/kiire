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

  it "should save place settings when saved" do
    ps = Factory.build(:place_setting, :place => @place)
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

    it "should not require a (serialized) style" do
      @place.serialized_style = nil
      @place.should be_valid
    end
  end

  describe "#get_setting" do
    before do
      @backend = mock(Class)
      @backend.stub!(:is_a?).with(Class).and_return(true)
      @backend.stub!(:name => 'my_backend')

      @result = mock(Object)
    end

    it "should return an existing setting given a key" do
      @place.settings.should_receive(:find).twice.with(:first, :conditions => { :key => 'foo', :backend => 'my_backend' }).and_return(@result)
      @place.get_setting('foo', @backend).should == @result
      @place.get_setting('foo', 'my_backend').should == @result
    end

    it "should return a new setting given a key to a nonexistent setting" do
      @place.settings.should_receive(:find).twice.with(:first, :conditions => { :key => 'foo', :backend => 'my_backend' }).and_return(nil)
      @place.settings.should_receive(:new).twice.with(:key => 'foo', :backend => 'my_backend').and_return(@result)
      @place.get_setting('foo', @backend).should == @result
      @place.get_setting('foo', 'my_backend').should == @result
    end

    it "should default to a nil backend" do
      @place.settings.should_receive(:find).with(:first, :conditions => { :key => 'foo', :backend => nil }).and_return(@result)
      @place.get_setting('foo').should == @result
    end
  end
end
