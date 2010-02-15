# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_kiire_session',
  :secret      => 'f8cdf42d6f5ea66d4432831c37b7cfaf06164345c217e910f33ed48a3197687b0830af74a6f45b873f802c10f1daf945acc6b5f880b18a9c30a64c5a5e5371a6'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
