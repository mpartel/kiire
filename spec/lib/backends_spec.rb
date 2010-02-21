
require 'spec_helper'

describe Backends do
  it "should have a default backend" do
    Backends::Default.should be_a(Class)
  end

  describe "#by_name" do
    it "should return the correct backend" do
      backend = mock(Class)
      Backends.should_receive(:const_get).with('ReittienOpastaja').and_return(backend)
      Backends.by_name("reittien_opastaja").should == backend
    end

    it "should return nil if no such backend exists" do
      Backends.should_receive(:const_get).with('ReittienOpastaja').and_return(nil)
      Backends.by_name("ReittienOpastaja").should == nil
    end
  end
end