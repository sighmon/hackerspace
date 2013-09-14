class RegistrationsController < Devise::RegistrationsController

	before_action :set_user, only: [:show, :edit, :update, :destroy]

	def create
		@user = User.new(user_params)
		respond_to do |format|
			if @user.save
				format.html { redirect_to @user, notice: 'User was successfully created.' }
				format.json { head :no_content }
			else
				format.html { render action: 'create' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	def update
		respond_to do |format|
			if @user.update(user_params)
				format.html { redirect_to @user, notice: 'User was successfully updated.' }
				format.json { head :no_content }
			else
				format.html { render action: 'edit' }
				format.json { render json: @user.errors, status: :unprocessable_entity }
			end
		end
	end

	private

	def set_user
		@user = User.find(current_user)
	end

	def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation, :remember_me)
	end

end
