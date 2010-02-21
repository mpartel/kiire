class Place < ActiveRecord::Base
  belongs_to :user
  has_many :settings, :class_name => 'PlaceSetting'

  validates_presence_of :name
end
