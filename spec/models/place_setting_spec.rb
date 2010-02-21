require 'spec_helper'

describe PlaceSetting do
  before do
    @ps = Factory.build(:place_setting)
  end

  it "belongs to a place" do
    @ps.place.should be_a(Place)
  end

  describe "validation" do
    it "should pass when created by the default factory" do
      @ps.should be_valid
    end

    it "should require a place" do
      @ps.place = nil
      @ps.should have(1).errors_on(:place)
    end

    it "should not require a backend" do
      @ps.backend = nil
      @ps.should have(0).errors_on(:backend)
    end

    it "should require the backend to be a valid backend" do
      Backends.should_receive(:by_name).with('reittien_opastaja').and_return(mock(Class))
      @ps.backend = 'reittien_opastaja'
      @ps.should have(0).errors_on(:backend)

      Backends.should_receive(:by_name).with('teiden_nayttaja').and_return(nil)
      @ps.backend = 'teiden_nayttaja'
      @ps.should have(1).errors_on(:backend)
    end

    it "should allow setting the backend as a class" do
      module ::Backends
        class MyTestBackend
        end
      end

      @ps.backend = Backends::MyTestBackend
      @ps.backend.should == 'my_test_backend'
    end

    it "should require a key" do
      @ps.key = nil
      @ps.should have(1).error_on(:key)
    end

    it "should not require a value" do
      @ps.value = nil
      @ps.should have(0).errors_on(:value)
    end

    it "should require that the key is not a duplicate (for the place and backend)" do
      @ps.save
      ps2 = Factory.build(:place_setting,
                          :place_id => @ps.place_id,
                          :key => @ps.key,
                          :backend => @ps.backend)
      ps2.should_not be_valid
    end
  end
end
