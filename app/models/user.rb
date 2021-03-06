class User < ActiveRecord::Base
  has_many :likes
  has_many :bookmarks, dependent: :destroy
  has_many :category_users
  has_many :categories, through: :category_users

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :omniauthable, :omniauth_providers => [:facebook]

  def liked(bookmark)
    likes.where(bookmark_id: bookmark.id).first
  end

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.name = auth.info.name
    end
  end
end
