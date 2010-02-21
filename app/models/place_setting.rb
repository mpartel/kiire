class PlaceSetting < ActiveRecord::Base
  belongs_to :place

  validates_presence_of :place, :key
  validates_uniqueness_of :key, :scope => [:place_id, :backend]
  validate :backend_must_exist

  def backend=(new_backend)
    if new_backend.is_a?(Class)
      new_backend = new_backend.to_s[/^Backends::(.*)$/, 1]
      new_backend = new_backend.underscore if new_backend
    end
    super(new_backend)
  end

private
  def backend_must_exist
    if self.backend
      cls = Backends.by_name(self.backend)
      errors.add(:backend, I18n.t("place_settings.invalid_backend")) unless cls
    end
  end
end
