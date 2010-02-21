
require 'spec_helper'

describe Backends do
  it "should have a default backend" do
    Backends::Default.should be_a(Class)
  end
end