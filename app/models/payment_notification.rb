class PaymentNotification < ActiveRecord::Base

	belongs_to :user
	serialize :params
	after_create :update_membership

private
	def update_membership
		# Log for testing.
		# logger.info params

		# TODO: Check that the ipn_url is working on real server.

		if transaction_type == "express_checkout"
			# Ignore this. It's an instant payment that's been handled.
			logger.info "Express checkout IPN ping received. TXN_ID: #{transaction_id}"
		elsif params["test_ipn"] == "1"
			# Ignore test IPNs.
			logger.info "Test IPN ping received. TXN_ID: #{transaction_id}"
		elsif transaction_type == "cart"
			# Ignore this. It's an instant payment that's been handled.
			logger.info "Instant purchase IPN ping received. TXN_ID: #{transaction_id}"
		elsif transaction_type == "web_accept"
			# This is a ping from our web shop.
			logger.info "Web Accept IPN ping received. TXN_ID: #{transaction_id}"
		elsif transaction_type == "send_money"
			# This is someone manually sending us money.
			logger.info "Send Money IPN ping received. TXN_ID: #{transaction_id}"
		elsif params["payment_type"] == "echeck"
			# This is a PayPal echeck refund or payment
			logger.info "echeck IPN ping received. TXN_ID: #{transaction_id}"
		elsif status == "Refunded"
			# This is a refund made through the paypal interface
			logger.info "Refund IPN ping received. TXN_ID: #{transaction_id}"
		elsif transaction_type == "recurring_payment_profile_created"
			# PayPal letting us know that the profile was created successfully
			if User.find(self.user_id).try(:first_recurring_membership,params["recurring_payment_id"])
				logger.info "Recurring payment profile created: #{params["recurring_payment_id"]}"
			else
				logger.warn "Did not find matching membership for 'recurring_payment_profile_created' IPN: #{params["recurring_payment_id"]}"
			end
		else
			@user = User.find(self.user_id)

			# Test to see if it's a membership renewal, or a membership cancellation
			if status == "Completed" and transaction_type == "recurring_payment" and params["profile_status"] == "Active"
				# It's a recurring membership debit
				# Find out how many months & update expiry_date
				# PayPal doesn't send us back the membership :frequency, so we need to calculate that from initial recurring membership
				first_recurring_membership = @user.first_recurring_membership(params["recurring_payment_id"])
				# old hack method
				# months = params[:mc_gross].to_i / ( Settings.membership_price / 100 )
				renew_membership(first_recurring_membership)
				logger.info "membership renewed for another #{first_recurring_membership.duration} months."

			elsif params["profile_status"] == "Cancelled" and transaction_type == "recurring_payment_profile_cancel"
				# It's a recurring membership cancellation.
				if @user.membership_valid?
					expire_recurring_memberships(@user)
					logger.info "Recurring memberships expired successfully."
					# send a special email saying cancelled through paypal.
					UserMailer.membership_cancelled_via_paypal(user).deliver
				else
					logger.info "membership already cancelled."
				end
			else
				logger.info "Unknown transaction."
			end
		end		
	end

	def expire_recurring_memberships(user)
		all_memberships = user.recurring_memberships(params["recurring_payment_id"])
		all_memberships.each do |s|
			s.expire_membership
			s.save
			logger.info "Refund for membership id: #{s.id} is #{s.refund} cents."
			logger.info "Expired membership id: #{s.id} - cancel date: #{s.cancellation_date}"
		end
	end

	def renew_membership(first_recurring_membership)
		@membership = membership.create(
			:paypal_profile_id => params["recurring_payment_id"],
			:paypal_payer_id => params["payer_id"],
			:paypal_email => params["payer_email"],
			:paypal_first_name => params["first_name"],
			:paypal_last_name => params["last_name"],
			:price_paid => (params["mc_gross"].to_i * 100), 
			:user_id => @user.id, 
			:valid_from => (@user.last_membership.try("expiry_date") or DateTime.now), 
			:duration => first_recurring_membership.duration,
			:paper_copy => first_recurring_membership.paper_copy,
			:purchase_date => DateTime.now
		)
		if @membership.save
			logger.info "membership save successful"
		else
			logger.error "membership save unsuccessful"
		end
	end
end
