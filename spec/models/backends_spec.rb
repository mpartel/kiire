
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

  describe "#all" do
    it "should return all backend classes" do
      constants = ["Backend", "Default", "FooBar", "MooFar"]
      backend = mock(Class)
      non_backend = mock(Class)
      backend.stub!(:superclass => Backends::Backend)
      non_backend.stub!(:superclass => Object)

      Backends.should_receive(:constants).and_return(constants)
      Backends.stub!(:const_get).with("Backend").and_return(Backends::Backend)
      Backends.stub!(:const_get).with("Default").and_return(backend)
      Backends.stub!(:const_get).with("FooBar").and_return(backend)
      Backends.stub!(:const_get).with("MooFar").and_return(non_backend)

      Backends.all.should == [backend]
    end
  end
end