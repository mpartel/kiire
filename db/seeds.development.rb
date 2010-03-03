
user = User.create!(:username => 'user',
                    :password => 'user',
                    :password_confirmation => 'user')

rautatientori = user.places.create!(:name => 'Rautatientori')
kumpulan_kampus = user.places.create!(:name => 'Kumpulan Kampus')
lansisatama = user.places.create!(:name => 'Länsisatama')

kumpulan_kampus.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => 'Kumpulan Kampus, Helsinki')
lansisatama.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => nil)
