require 'spec_helper.rb'

describe HostnameHelper do
  describe "#with_regular_hostname" do
    describe "given a url" do
      it "should return the url without the username in the hostname" do
        helper.stub!(:current_url => 'http://foo.bar:123/zoo')
        helper.should_receive(:hostname_without_username).and_return('foo.bar')
        result = helper.with_regular_hostname('http://user.foo.bar:123/moo')
        result.should == 'http://foo.bar:123/moo'
      end
    end

    describe "given a path" do
      it "should return the url without the username in the hostname" do
        helper.stub!(:current_url => 'http://foo.bar:123/zoo')
        helper.should_receive(:hostname_without_username).and_return('foo.bar')
        result = helper.with_regular_hostname('/moo/456')
        result.should == 'http://foo.bar:123/moo/456'
      end
    end
  end
end
