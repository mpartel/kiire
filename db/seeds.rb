
demouser = User.create!(:username => 'demo',
                        :password => nil,
                        :password_confirmation => nil)

rautatientori = demouser.places.create!(:name => 'Rautatieasema')
koulu = demouser.places.create!(:name => 'Koulu')
koti = demouser.places.create!(:name => 'Koti')
lansisatama = demouser.places.create!(:name => 'Länsisatama')
itakeskus = demouser.places.create!(:name => 'Itäkeskus')


koulu.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => 'Kumpulan Kampus, Helsinki')
koti.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => 'Mäkkylä')
lansisatama.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => nil)

require File.join(File.dirname(__FILE__), 'seeds.development.rb') if Rails.env.development?
