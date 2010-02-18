class User < ActiveRecord::Base
  has_many :settings, :dependent => :destroy
  has_many :places, :dependent => :destroy

  validates_presence_of :username
  validates_uniqueness_of :username

  attr_accessor :password, :password_confirmation
  validate :password_and_password_confirmation_match
  before_save :attempt_password_reset

  def self.authenticate(username, password)
    hash = hash_password(password)
    return User.find_by_username_and_password_hash(username, hash)
  end

  def self.hash_password(plaintext)
    Digest::SHA1.hexdigest(plaintext.to_s)
  end

private
  def password_and_password_confirmation_match
    if @password and @password != @password_confirmation
      errors.add(:password_confirmation, I18n.t("user.passwords_do_not_match"))
    end
  end

  def attempt_password_reset
    if @password and @password == @password_confirmation
      self.password_hash = User.hash_password(@password)
    end
  end
end
