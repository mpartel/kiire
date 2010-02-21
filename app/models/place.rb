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
end
