class Place < ActiveRecord::Base
  belongs_to :user
  has_many :settings, :class_name => 'PlaceSetting'

  validates_presence_of :name

  def get_setting(key, backend = nil)
    backend = backend.name if backend.is_a?(Class)
    setting = settings.find(:first, :conditions => { :key => key, :backend => backend })
    setting = settings.new(:key => key, :backend => backend) unless setting
    return setting
  end

  def client_attributes
    result = {}
    result['id'] = self.id
    result['name'] = self.name
    result['settings'] = self.settings_as_client_attributes
    return result
  end

protected
  def settings_as_client_attributes
    result = {}
    self.settings.each do |setting|
      if setting.backend
        result[setting.backend] = {} unless result[setting.backend]
        target = result[setting.backend]
      else
        target = result
      end

      target[setting.key] = setting.value
    end
    return result
  end
end
