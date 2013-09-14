class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  def is_admin?
  	# TODO: add admin flag to Users
  	return true
  end

  def has_membership?
  	# TODO: write code to test for a current membership
  	return false
  end

end