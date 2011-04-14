require 'lib/backends/reittiopas.rb'

module Backends
  Default = Backends::Reittiopas unless const_defined? 'Default'

  def self.by_name(name)
    self.const_get(name.to_s.camelize(:upper))
  end

  def self.all
    classes = self.constants.map {|c| self.const_get(c) }
    classes = classes.select {|c| c.superclass == Backends::Backend }
    classes - [Backends::Backend]
    classes.uniq!
    return classes
  end
end

Dir.glob(File.dirname(__FILE__) + '/backends/*.rb') do |file|
  require file
end
