class UsersController < ApplicationController

	before_filter :authenticate_user!, except: [:show, :checkin]
	# Below was for testing only.
	skip_before_action :verify_authenticity_token, only: [:checkin]

	def show
		@user = User.find(params[:id])
	end

	def register_card
		@user = User.find(params[:user_id])
		if @user
			@user.nfc_atr = Base64.decode64(params[:atr])#.unpack('H*')
			@user.nfc_id = Base64.decode64(params[:id])#.unpack('H*')

			if @user.save
				render json: user_hash(@user)
			else
				render json: nil
			end

		else
			render json: nil
		end

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
		@nfc_id = Base64.decode64(params[:id])#.unpack('H*')
		# Ignoring params[:atr] for now
		# @nfc_atr = Base64.decode64(params[:atr])#.unpack('H*')
		# @user = User.find_by_nfc_atr_and_nfc_id(@nfc_atr, @nfc_id)
		@user = User.find_by_nfc_id(@nfc_id)
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
				render json: nil, status: 403
			else
				# Check in!
				@checkin = @user.checkins.build
				if @checkin.save
					logger.info "Successfully checked in user: #{@user.username}"
					render json: user_hash(@user)
				else
					logger.info "Error checking in user: #{@user.username}"
					render json: nil, status: 500
				end
			end
		else
			logger.info "Couldn't find a user for this card."
			render json: nil, status: 403
		end
	end

	def user_hash(user)
		hash = { :id => user.id, :username => user.username, :joined => user.created_at, :checkins => user.checkins }
		if current_user && current_user.is_admin?
			hash[:nfc_atr] = user.nfc_atr
			hash[:nfc_id] = user.nfc_id
		end
		hash
	end

end
