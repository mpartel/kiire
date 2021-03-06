require 'spec_helper'

describe Setting do
  before do
    @setting = FactoryGirl.build(:setting)
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
      s2 = FactoryGirl.build(:setting, :user => @setting.user)
      s3 = FactoryGirl.build(:setting, :user => @setting.user, :key => @setting.key)

      s2.should be_valid
      s3.should_not be_valid
    end
  end

  describe "::default_value" do
    before do
      Setting.clear_cache

      configuration = {
        'foo' => 'bar',
        'boo' => {
          'hoo' => 'goo'
        }
      }
      YAML.stub!(:load_file).with(Setting::DEFAULT_SETTINGS_PATH).and_return(configuration)
    end

    it "should return the default value from the configuration" do
      Setting.default_value('foo').should == 'bar'
      Setting.default_value('boo.hoo').should == 'goo'
      Setting.default_value('moo.moo').should == nil
    end

    it "should cache the default value configuration" do
      YAML.should_receive(:load_file).at_most(1).with(Setting::DEFAULT_SETTINGS_PATH).and_return({'foo' => 'bar'})
      Setting.default_value('foo')
      Setting.default_value('foo')
      Setting.default_value('boo')
    end
  end
end
