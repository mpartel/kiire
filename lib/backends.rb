module Backends
  Default = Backends::Reittiopas

  def self.by_name(name)
    self.const_get(name.to_s.camelize(:upper))
  end
end