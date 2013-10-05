class Membership < ActiveRecord::Base

	belongs_to :user

	validates_presence_of :valid_from, :duration

end
