class Setting < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :key
  validates_uniqueness_of :key, :scope => :user_id

  DEFAULT_SETTINGS_PATH = 'config/default_settings.yml'

  def self.default_value(key)
    @default_settings = YAML.load_file(DEFAULT_SETTINGS_PATH) unless @default_settings
    @default_settings[key.to_s]
  end
end
