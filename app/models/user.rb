# == Schema Information
#
# Table name: users
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  email      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
#実際にデータベースにアクセスしたりして、作業する場所。ここに
#記述したものが、データベースに反映される。

class User < ActiveRecord::Base
#attr_accessibleでハッシュでの引き渡しを許可させる
  attr_accessible :email, :name, :password, :password_confirmation
  has_secure_password
  has_many :microposts, dependent: :destroy
#  Userクラスのインスタンスをsaveする前に、email.downcase、
#つまり、emailアドレスを全て小文字に変換した後で保存するような処理を追加する、
#ということ
before_save { email.downcase! }
#save前にcreate_remember_tokenを作成する
before_save :create_remember_token
#before_save { |user| user.email = email.downcase }

#presenceをtrueにすることで、記入無しを防げる
#length: { maximum: 50 }で名前の長さを最大50文字と指定しているので
#rpsecのテストで引っかからない。
  validates :name,  presence: true, length: { maximum: 50 }

  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
#uniqueness: trueでダブりを防ぐ
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
		uniqueness: { case_sensitive: false }
  validates_confirmation_of :password
  validates :password, length: { minimum: 6 }
  validates :password_confirmation, presence: true

  def feed
    Micropost.where("user_id = ?",id)
  end

  private
   def create_remember_token
#SecureRandom.urlsafe_base64 returns a random string of length 16 composed of
# the characters A–Z, a–z, 0–9, “-”, and “_” (for a total of 64 possibilities)
	self.remember_token = SecureRandom.urlsafe_base64
   end
end
