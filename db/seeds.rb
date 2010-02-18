
user = User.create!(:username => 'user',
                    :password => 'user',
                    :password_confirmation => 'user')

user.places.create!(:name => 'Rautatientori')
user.places.create!(:name => 'Kumpulan Kampus')
