# Ruby 1.8.6 doesn't have Array#take and Array#drop
unless [].respond_to? 'take'
  class Array
    def take(n)
      self[0...n]
    end
    def drop(n)
      self[n..-1]
    end
  end
end