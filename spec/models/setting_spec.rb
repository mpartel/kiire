require 'spec_helper'

describe Setting do
  before do
    @setting = Factory.build(:setting)
  end

  it "should belong to a user" do
    @setting.should respond_to(:user)
    @setting.user.should be_a(User)
  end

  describe "when validated" do
    it "should be valid when constructred by the factory" do
      @setting.should be_valid
    end

    it "must belong to a user" do
      @setting.user = nil
      @setting.should have(1).error_on(:user)
    end

    it "requires a key" do
      @setting.key = nil
      @setting.should have(1).error_on(:key)
    end

    it "does not require a value" do
      @setting.value = nil
      @setting.should have(0).errors_on(:user)
    end

    it "needs to have a unique key in the scope of its user" do
      @setting.save!
      s2 = Factory.build(:setting, :user => @setting.user)
      s3 = Factory.build(:setting, :user => @setting.user, :key => @setting.key)

      s2.should be_valid
      s3.should_not be_valid
    end
  end
end
