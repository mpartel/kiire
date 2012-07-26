class Place < ActiveRecord::Base
  belongs_to :user
  has_many :settings, :class_name => 'PlaceSetting'

  validates :name, :presence => true
  validates :ordinal, :uniqueness => { :scope => :user_id }

  attr_accessible :name, :ordinal

  before_create :set_default_ordinal

  def get_setting(key, backend = nil)
    backend = backend.name if backend.is_a?(Class)
    setting = settings.where(:key => key, :backend => backend).first
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

  def set_default_ordinal
    if ordinal == 0
      db = ActiveRecord::Base.connection
      sql = "SELECT MAX(ordinal) + 1 AS o FROM places WHERE user_id = #{user_id}"
      self.ordinal = db.select_value(sql) || 1
    end
  end
end
