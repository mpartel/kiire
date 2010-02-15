if Rails.env.development? or Rails.env.test? or Rails.env.cucumber?
  class Object
    def id
      # This is normally a warning
      raise "You called #{self.class}#id (Object#id), which is deprecated. Maybe you meant to call it on an active record."
    end
  end
end