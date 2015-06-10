class User < ActiveRecord::Base
  rolify
  has_secure_password
  has_many :dashboards
  def self.authenticate(email, password)
  user = find_by_email(email)
  if user && user.password_digest == BCrypt::Engine.hash_secret(password, user.password_digest)
    user
  else
    nil
  end
end
end
