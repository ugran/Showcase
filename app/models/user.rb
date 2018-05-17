class User < ApplicationRecord
  devise :two_factor_backupable, :two_factor_authenticatable, :otp_secret_encryption_key => 'Kyf72Bnmaf812FsRE4Kyf72Bnmaf812FsRE4', otp_backup_code_length: 32, otp_number_of_backup_codes: 1

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :registerable, :rememberable, :trackable, :validatable#, confirmable, #recoverable

  has_many :miners
  belongs_to :group, optional: true
  has_one :user_balance
  has_one :personal_information
  has_many :payouts
end
