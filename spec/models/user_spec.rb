# -*- coding: UTF-8 -*-
require 'spec_helper'

describe User do

  before do
    @user = FactoryGirl.build(:user)
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
        @user.save!
        user2 = FactoryGirl.build(:user, :username => @user.username)
        user2.should have(1).error_on(:username)
      end

      it "must be unique case-insensitively" do
        @user.username = 'jussi'
        @user.save!
        user2 = FactoryGirl.build(:user, :username => 'Jussi')
        user2.should have(1).error_on(:username)
      end

      it "permits only ascii letters, numbers, dashes and underscores" do
        @user.username = "123_ai-FOO"
        @user.should have(0).errors_on(:username)

        @user.username = "mää"
        @user.should have(1).errors_on(:username)

        @user.username = "me/h"
        @user.should have(1).errors_on(:username)
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

    describe "to the empty string" do
      before do
        @user.password = ""
        @user.password_confirmation = ""
      end

      it "should fail validation" do
        @user.should have(1).error_on(:password)
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
      hashed_password = Digest::SHA1.hexdigest('hello').encode('UTF-8')
      @user.password_hash = hashed_password
      @user.save!

      result = User.authenticate(@user.username, 'hello')

      result.should == @user
    end

    it "should be case-insensitive with the username" do
      @user.username = 'jussi'
      hashed_password = Digest::SHA1.hexdigest('hello').encode('UTF-8')
      @user.password_hash = hashed_password
      @user.save!

      result = User.authenticate('Jussi', 'hello')

      result.should == @user
    end
  end

  describe "#find_by_username_case_insensitive" do
    describe "when there are no matching users" do
      it "should return nil" do
        @user.destroy
        User.find_by_username_case_insensitive('jussi').should be_nil
      end
    end

    describe "when there is one matching user" do
      describe "with matching case" do
        it "should find it" do
          @user.username = 'jussi'
          @user.save!
          User.find_by_username_case_insensitive('jussi').should == @user
        end
      end

      describe "with mismatching case" do
        it "should find it" do
          @user.username = 'jussi'
          @user.save!
          User.find_by_username_case_insensitive('Jussi').should == @user
        end
      end
    end
  end

  it "should have settings" do
    @user.should respond_to(:settings)
    @user.settings.should be_a(Enumerable)
  end

  it "should save its settings when saved" do
    setting = FactoryGirl.build(:setting, :user => @user)
    @user.settings << setting
    setting.should be_new_record
    @user.save
    setting.should_not be_new_record
  end

  describe "#get_setting" do
    describe "when the setting doesn't exist" do
      it "should return a new setting with a default value" do
        Setting.should_receive(:default_value).with('foo').and_return('bar')
        result = @user.get_setting('foo')
        result.should be_new_record
        result.key.should == 'foo'
        result.value.should == 'bar'
      end
    end

    describe "when the setting exists" do
      it "should return the setting" do
        setting = FactoryGirl.create(:setting, :user => @user, :key => 'foo')
        @user.get_setting(:foo).should == setting
      end
    end
  end

  describe "#get_setting_value" do
    describe "when the setting doesn't exist" do
      it "should return a new setting with a default value" do
        Setting.should_receive(:default_value).with('foo').and_return('bar')
        result = @user.get_setting_value('foo')
        result.should == 'bar'
      end
    end

    describe "when the setting exists" do
      it "should return the setting" do
        setting = FactoryGirl.create(:setting, :user => @user, :key => 'foo', :value => 'boo')
        @user.get_setting_value(:foo).should == 'boo'
      end
    end
  end

  it "should have places" do
    @user.should respond_to(:places)
    @user.places.should be_a(Enumerable)
  end

  describe "places" do
    before do
      @user.save!
      @p1 = FactoryGirl.create(:place, :user => @user, :ordinal => 1)
      @p2 = FactoryGirl.create(:place, :user => @user, :ordinal => 2)
      @p3 = FactoryGirl.create(:place, :user => @user, :ordinal => 3)
      @user.places.reload
    end

    it "should be ordered by creation order by default" do
      @user.places[0].should == @p1
      @user.places[1].should == @p2
      @user.places[2].should == @p3
    end

    it "should be ordered by their ordinals" do
      @p1.ordinal = @p3.ordinal + 1
      @p1.save!
      @user.places.reload

      @user.places[0].should == @p2
      @user.places[1].should == @p3
      @user.places[2].should == @p1
    end

    it "can be moved after other places" do
      @user.move_place_after(@p1, @p2)
      @user.places[0].should == @p2
      @user.places[1].should == @p1
      @user.places[2].should == @p3

      @user.move_place_after(@p3, @p2)
      @user.places[0].should == @p2
      @user.places[1].should == @p3
      @user.places[2].should == @p1
    end

    it "can be moved to be the first place" do
      @user.move_place_after(@p3, nil)
      @user.places[0].should == @p3
      @user.places[1].should == @p1
      @user.places[2].should == @p2
    end

    it "can be moved from the first place" do
      @user.move_place_after(@p1, @p2)
      @user.places[0].should == @p2
      @user.places[1].should == @p1
      @user.places[2].should == @p3
    end

    it "can be moved after themselves for no effect" do
      def check_order
        @user.places[0].should == @p1
        @user.places[1].should == @p2
        @user.places[2].should == @p3
      end

      @user.move_place_after(@p1, nil)
      check_order
      @user.move_place_after(@p1, @p1)
      check_order
      @user.move_place_after(@p2, @p2)
      check_order
      @user.move_place_after(@p3, @p3)
      check_order
    end
  end

  describe "when destroyed" do
    before do
      @user.save!
    end

    it "should destroy its settings" do
      setting = FactoryGirl.create(:setting, :user => @user)
      @user.settings.should include(setting)
      @user.destroy
      Setting.exists?(setting.id).should be_false
    end

    it "should destroy its places" do
      place = FactoryGirl.create(:place, :user => @user)
      @user.places.should include(place)
      @user.destroy
      Place.exists?(place.id).should be_false
    end
  end

end
