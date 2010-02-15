class User < ActiveRecord::Base
  validates_presence_of :username

  def password=(password)
    self.password_hash = Digest::SHA1.hexdigest(password)
  end
end
