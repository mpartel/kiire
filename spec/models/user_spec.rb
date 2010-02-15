require 'spec_helper'

describe User do

  before do
    @user = Factory.build(:user)
  end

  describe "validation" do
    before do
      @user.should be_valid
    end

    describe "of username" do
      it "may not be null" do
        @user.username = nil
        @user.should have(1).error_on(:username)
      end

      it "may not be empty" do
        @user.username = ""
        @user.should have(1).error_on(:username)
      end
    end

    describe "of password_hash" do
      it "may be null" do
        @user.password_hash = nil
        @user.should be_valid
      end
    end

    describe "of email" do
      it "may be null" do
        @user.email = nil
        @user.should be_valid
      end
    end
  end

  describe "password" do
    it "is not readable" do
      lambda do
        @user.password
      end.should raise_error
    end

    it "sets the password hash when set" do
      @user.password = 'hello'
      @user.password_hash.should == Digest::SHA1.hexdigest('hello')
    end
  end

end
