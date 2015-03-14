class UsersController < ApplicationController

	before_filter :authenticate_user!, except: [:show]
	# Below was for testing only.
	# skip_before_action :verify_authenticity_token, only: [:lookup]

	def show
		@user = User.find(params[:id])
	end

	def lookup
		@nfc_atr = Base64.decode64(params[:atr])#.unpack('H*')
		@nfc_id = Base64.decode64(params[:id])#.unpack('H*')
		@user = User.find_by_nfc_atr_and_nfc_id(@nfc_atr, @nfc_id)
		if @user
			render json: @user.id
		else
			render json: nil
		end
	end

end
