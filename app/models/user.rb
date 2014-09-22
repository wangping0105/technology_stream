#encoding:utf-8
class User < ActiveRecord::Base
  validates :name, presence: true,uniqueness: true
  validates :email, presence: true,uniqueness: true
  before_create :create_remember_token
  has_secure_password
  SCREENSHOT_SIZE = [298]
  AVATAR_SIZE = [176]
  TEAVHER_URL = "/assets/guest.jpg"
  STATUS = { normal:0,freezn:1}
  SEX={man:0,women:1}
  SEX_NAME = {0=>'男',1=>'女'}
  def self.new_remember_token
    SecureRandom.urlsafe_base64
  end
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

  def admin?
    if self.role == 1
      return true
    end
    false
  end
  private
    def create_remember_token
      self.remember_token = User.encrypt(User.new_remember_token)
      self.avatar_url = TEAVHER_URL
      self.status = 0
    end
end
