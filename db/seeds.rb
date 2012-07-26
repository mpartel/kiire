# -*- coding: UTF-8 -*-
demouser = User.create!(:username => 'demo',
                        :password => nil,
                        :password_confirmation => nil)

setting = demouser.get_setting('dont_require_login')
setting.value = '1'
setting.save!

demouser.places.create!(:name => 'Rautatieasema')
koulu = demouser.places.create!(:name => 'TKTL')
koti = demouser.places.create!(:name => 'Koti')
kaisla = demouser.places.create!(:name => 'Kaisla')
lansisatama = demouser.places.create!(:name => 'Länsisatama')
demouser.places.create!(:name => 'Itäkeskus')


koulu.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => 'Kumpulan kampus')
koti.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => 'Mäkkylä')
kaisla.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => 'Vilhonkatu 4')
lansisatama.settings.create!(:backend => 'reittiopas', :key => 'address_for', :value => nil)

require File.join(File.dirname(__FILE__), 'seeds.development.rb') if Rails.env.development?
