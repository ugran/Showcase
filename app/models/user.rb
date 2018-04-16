class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :rememberable, :trackable, :validatable#, confirmable, #recoverable

  has_many :miners
  belongs_to :group, optional: true
  has_one :user_balance
  has_one :personal_information
end
