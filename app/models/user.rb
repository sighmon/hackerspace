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
  	return self.admin
  end

  def expiry_date
    # FIXME: check for cancelled memberships
    return self.memberships.collect{|s| s.expiry_date}.sort.last
  end

  def has_membership?
  	return membership_valid?
  end

  def membership_valid?
    return self.memberships.collect{|s| s.is_current?}.include?(true)
  end

  def membership_lapsed?
    return ( not self.memberships.empty? and not self.membership_valid? )
  end

  def is_recurring?
    # TODO: need to differentiate between the first recurring memberships and the paypal IPN recurrances.
    return self.memberships.collect{|s| s.is_recurring?}.include?(true)
  end

  def recurring_subscription
    return self.memberships.select{|s| s.is_recurring?}.sort!{|a,b| a.expiry_date <=> b.expiry_date}.last
  end

  def last_membership
    return self.current_memberships.sort!{|a,b| a.expiry_date <=> b.expiry_date}.last
  end

  def current_memberships
    return self.memberships.select{|s| s.is_current?}
  end

  def user_type
    t = "Guest"
    if admin?
      t = "Admin"
    elsif has_membership?
      t = "Member"
    end
    "#{t}"
  end

  def guest?
    return id.nil?
  end

end