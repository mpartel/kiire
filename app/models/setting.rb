class Setting < ActiveRecord::Base
  belongs_to :user
  validates_presence_of :user, :key
  validates_uniqueness_of :key, :scope => :user_id
end
