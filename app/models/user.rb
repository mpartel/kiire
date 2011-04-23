class User < ActiveRecord::Base
  has_many :settings, :dependent => :destroy
  has_many :places, :order => 'ordinal ASC', :dependent => :destroy

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

  def move_place_after(place_to_move, after_or_nil)
    new_places = self.places.map(&:id).to_a
    old_index = new_places.index place_to_move.id
    new_index =
      if after_or_nil == nil
      then 0
      else new_places.index(after_or_nil.id) + 1
      end

    new_places.delete_at(old_index)
    if new_index > old_index
      new_index -= 1
    end
    new_places.insert(new_index, place_to_move.id)

    # We need to conform to the uniqueness constraint of ordinals after each update.
    # To be sure we do, we write the ordinals as negative and then
    # switch them back to positive all at once.

    db = ActiveRecord::Base.connection
    transaction do
      new_places.each_with_index do |id, index|
        db.execute "UPDATE places SET ordinal = -#{index + 1} WHERE id = #{id} AND user_id = #{self.id}"
      end
      db.execute "UPDATE places SET ordinal = ABS(ordinal) WHERE user_id = #{self.id}"
    end
    self.places.reload
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
