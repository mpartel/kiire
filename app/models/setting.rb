class Setting < ActiveRecord::Base
  belongs_to :user
  validates :user, :presence => true
  validates :key, :presence => true
  validates_uniqueness_of :key, :scope => :user_id
  attr_accessible :key, :value

  DEFAULT_SETTINGS_PATH = File.join(Rails.root, 'config', 'default_settings.yml')

  def self.default_value(key)
    @default_settings ||= YAML.load_file(DEFAULT_SETTINGS_PATH)
    
    key = key.to_s
    
    p = @default_settings
    key.split('.').each do |part|
      if p.is_a? Hash
        p = p[part]
      else
        p = nil
      end
    end
    
    return p
  end

  def self.clear_cache
    @default_settings = nil
  end
end
