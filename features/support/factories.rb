
require 'factory_girl'
Dir.glob 'spec/factories/*.rb' do |file|
  require file
end
