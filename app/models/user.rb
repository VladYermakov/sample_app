class User < ActiveRecord::Base

  validates :name, presence: true, length: {maximum: 20, minimum: 3}
  VALID_EMAIL_REGEX = /\A[a-z0-9\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+(?:\.[a-z0-9\!\#\$\%\&\'\*\+\/\=\?\^\_\`\{\|\}\~\-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\z/
  validates :email, presence: true, format: {with: VALID_EMAIL_REGEX},
  									uniqueness: {case_sensetive: false}
  validates :password, length: {minimum: 6}

  before_save { self.email = email.downcase }

  has_secure_password

end
