class User < ActiveRecord::Base
  has_many :settings, :dependent => :destroy
  has_many :places, :dependent => :destroy

  validates :username, :presence => true
  validates_uniqueness_of :username, :case_sensitive => false
  validate :username_must_be_alphanumeric_with_dashes_and_underscores

  attr_accessor :password, :password_confirmation
  validate :password_and_password_confirmation_match
  validate :password_not_an_empty_string
  before_save :attempt_password_reset

  def self.authenticate(username, password)
    hash = hash_password(password)
    exact_match = User.find_by_username_and_password_hash(username, hash)
    if exact_match
      return exact_match
    else
      return User.find_all_by_password_hash(hash).select { |u| u.username.downcase == username.downcase }.first
    end
  end

  def self.hash_password(plaintext)
    require 'rubygems'
    require 'digest'
    Digest::SHA1.hexdigest(plaintext.to_s)
  end

  def self.find_by_username_case_insensitive(username)
    User.all.select { |u| u.username.downcase == username.downcase }.first
  end

  def get_setting(key)
    key = key.to_s
    settings.find_by_key(key) || settings.build(:key => key, :value => Setting.default_value(key))
  end

  def get_setting_value(key)
    get_setting(key).value
  end

private

  def username_must_be_alphanumeric_with_dashes_and_underscores
    unless username.to_s =~ /^[a-zA-Z0-9_-]*$/
      errors.add(:username, I18n.t("user.invalid_characters_in_username"))
    end
  end

  def password_and_password_confirmation_match
    if password and password != password_confirmation
      errors.add(:password_confirmation, I18n.t("user.password_confirmation_does_not_match"))
    end
  end

  def password_not_an_empty_string
    if password == ""
      errors.add(:password, I18n.t("user.password_may_not_be_empty"))
    end
  end

  def attempt_password_reset
    if password and password == password_confirmation
      self.password_hash = User.hash_password(password)
    end
  end
end
