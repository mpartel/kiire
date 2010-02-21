module Backends
  class Backend
    def self.name
      self.to_s[/^Backends::(.*)$/, 1].underscore
    end
  end
end