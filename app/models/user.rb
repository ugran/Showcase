class User < ApplicationRecord
  devise :two_factor_authenticatable,
         :otp_secret_encryption_key => 'Kyf72Bnmaf812FsRE4Kyf72Bnmaf812FsRE4'

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :rememberable, :trackable, :validatable#, confirmable, #recoverable

  has_many :miners
  belongs_to :group, optional: true
  has_one :user_balance
  has_one :personal_information
end
