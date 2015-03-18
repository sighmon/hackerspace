class UsersController < ApplicationController

	before_filter :authenticate_user!, except: [:show, :checkin]
	# Below was for testing only.
	skip_before_action :verify_authenticity_token, only: [:checkin]

	def show
		@user = User.find(params[:id])
	end

	def lookup
		@nfc_atr = Base64.decode64(params[:atr])#.unpack('H*')
		@nfc_id = Base64.decode64(params[:id])#.unpack('H*')
		@user = User.find_by_nfc_atr_and_nfc_id(@nfc_atr, @nfc_id)
		if @user
			render json: user_hash(@user)
		else
			render json: nil
		end
	end

	def checkin
		logger.info "Checkin!"
		@nfc_atr = Base64.decode64(params[:atr])#.unpack('H*')
		@nfc_id = Base64.decode64(params[:id])#.unpack('H*')
		@user = User.find_by_nfc_atr_and_nfc_id(@nfc_atr, @nfc_id)
		already_checked_in_today = false
		if @user
			# Check if user has checked in today yet?
			@user.checkins.each do |checkin|
				if checkin.created_at.to_date == Date.current
					already_checked_in_today = true
				end
			end
			if already_checked_in_today
				logger.info "SORRY: #{@user.username} has already checked in today."
				render json: nil
			else
				# Check in!
				@checkin = @user.checkins.build
				if @checkin.save
					logger.info "Successfully checked in user: #{@user.username}"
					render json: user_hash(@user)
				else
					logger.info "Error checking in user: #{@user.username}"
					render json: nil
				end
			end
		else
			logger.info "Couldn't find a user for this card."
			render json: nil
		end
	end

	def user_hash(user)
		{ :id => user.id, :username => user.username, :email => user.email, :joined => user.created_at, :checkins => user.checkins }
	end

end
