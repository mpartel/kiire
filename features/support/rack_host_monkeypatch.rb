require 'rack'

p Rack::Test.const_set('DEFAULT_HOST', "example.com")
