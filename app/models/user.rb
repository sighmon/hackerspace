class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :authentication_keys => [:login]

  # Validate username
  validates :username, :presence => true
  validates :username,
    :uniqueness => {
      :case_sensitive => false
    }

  # Association for memberships
  has_many :memberships

  # Virtual attribute for authenticating by either username or email
  # This is in addition to a real persisted field like 'username'
  attr_accessor :login

  def self.find_first_by_auth_conditions(warden_conditions)
    conditions = warden_conditions.dup
    if login = conditions.delete(:login)
      where(conditions).where(["lower(username) = :value OR lower(email) = :value", { :value => login.downcase }]).first
    else
      where(conditions).first
    end
  end

  def is_admin?
  	# TODO: add admin flag to Users
  	return true
  end

  def has_membership?
  	# TODO: write code to test for a current membership
  	return false
  end

end