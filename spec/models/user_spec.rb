require 'spec_helper'

describe User do

  before do
    @user = Factory.build(:user)
  end

  describe "when validating" do
    before do
      @user.should be_valid
    end

    describe "username" do
      it "may not be null" do
        @user.username = nil
        @user.should have(1).error_on(:username)
      end

      it "may not be empty" do
        @user.username = ""
        @user.should have(1).error_on(:username)
      end

      it "must be unique" do
        @user.save
        user2 = Factory.build(:user, :username => @user.username)
        user2.should have(1).error_on(:username)
      end
    end

    describe "password_hash" do
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
    it "is a transient virtual attribute" do
      @user.password = 'hello'
      @user.password.should == 'hello'
    end

    it "is initially nil" do
      @user.password.should be_nil
    end
  end

  describe "password_confirmation" do
    it "is a transient virtual attribute" do
      @user.password_confirmation = 'hello'
      @user.password_confirmation.should == 'hello'
    end

    it "is initially nil" do
      @user.password_confirmation.should be_nil
    end
  end

  describe "when password and password_confirmation are set" do
    describe "to the same value" do
      before do
        @user.password = 'hello'
        @user.password_confirmation = 'hello'
      end

      it "should set the password hash on save" do
        @user.save!
        @user.password_hash.should == Digest::SHA1.hexdigest('hello')
        @user.should_not be_changed
      end
    end

    describe "to a different value" do
      before do
        @user.password = 'hello'
        @user.password_confirmation = 'hullo'
      end

      it "should not set the password hash on save" do
        original_hash = @user.password_hash
        @user.save
        @user.password_hash.should == original_hash
      end

      it "should fail validation" do
        @user.should_not be_valid
        @user.should have(1).error_on(:password_confirmation)
      end
    end
  end

  describe "authentication" do
    it "should return the user if the given user and password are correct" do
      hashed_password = Digest::SHA1.hexdigest('hello')
      @user.password_hash = hashed_password
      @user.save!

      result = User.authenticate(@user.username, 'hello')

      result.should == @user
    end
  end

  it "should have settings" do
    @user.settings.should be_a(Enumerable)
  end

  it "should destroy its settings when destroyed" do
    setting = Factory.create(:setting, :user => @user)
    @user.settings.should include(setting)
    @user.destroy
    Setting.exists?(setting.id).should be_false
  end

  it "should save its settings when saved" do
    setting = Factory.build(:setting, :user => @user)
    @user.settings << setting
    setting.should be_new_record
    @user.save
    setting.should_not be_new_record
  end

end
