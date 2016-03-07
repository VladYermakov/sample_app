class User < ActiveRecord::Base

  validates :name, presence: true, length: {maximum: 50, minimum: 2}
  VALID_EMAIL_REGEX = /\A[a-z0-9\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+(?:\.[a-z0-9\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\z/
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
  									uniqueness: {case_sensetive: false}
  validates :password, length: {minimum: 6}

  before_save { self.email = email.downcase }
  before_create :create_remember_token

  has_secure_password

  has_many :microposts, dependent: :destroy

  def User.new_remember_token

  	SecureRandom.urlsafe_base64

  end

  def User.encrypt(token)

  	Digest::SHA1.hexdigest(token.to_s)

  end

  def feed

    Micropost.where("user_id = ?", id)

  end

  private

    def create_remember_token

  	  self.remember_token = User.encrypt(User.new_remember_token)

    end

end
